from pyspark.sql import SparkSession
import pyspark.sql.functions as F
from pyspark.sql.types import StructType, StructField, StringType

from datetime import datetime

spark = SparkSession.builder\
.appName("spark-apptracking-test")\
.getOrCreate()

hdfs_path = 'hdfs:///user/hadoop/extracted/*.gz'
# TODO set partition_dt for partitioned loading via argument
partition_dt='20240901'
s3_output_path='s3://dmp-dev-ap-northeast-1/tate/apptracking_v2/rawdata_parquet/'

schema_with_tab = StructType(
    [
        StructField("adid", StringType(), True),
        StructField("adid_details", StringType(), True),
        StructField("carrier", StringType(), True),
        StructField("device_model", StringType(), True),
        StructField("device_os", StringType(), True),
        StructField("gender", StringType(), True),
        StructField("age", StringType(), True),
    ]
)

df = (
    spark.read
        .option("inferSchema", "true")
        .option("delimiter", "\t")
        .option("multiLine", "true")
        .option("header", "false")
        .option("encoding", "utf-8")
        .csv(data_path, schema=schema_with_tab)
)

print(df.limit(4).show())

# adid_datails 컬럼 데이터 타입 리스트 형태로 변경
df = df.withColumn('splited', F.split(df["adid_details"], ","))

# 리스트 원소 각각의 레코드 값으로 explode (n * m 행렬 -> nm * 1 벡터로 변경하는 개념)
exploded_df = (
    df.select(
        df['adid'],
        F.explode(df["splited"]).alias('ad_id_details'),
    )
)

# : 로 구분된 package_name, install_market 등의 컬럼 값 뽑기
exploded_df = (
    exploded_df
    .withColumn('splited', F.split(exploded_df["ad_id_details"], ":"))
    .withColumn("package_name", F.col("splited").getItem(0))
    .withColumn("install_market", F.col("splited").getItem(1))
    .withColumn("first_install_dt", F.col("splited").getItem(2))
    .withColumn("last_update_dt", F.col("splited").getItem(3))
    .withColumn("last_use_dt", F.col("splited").getItem(4))
    .withColumn("daily_use_sec", F.col("splited").getItem(5))
    .withColumn("weekly_use_sec", F.col("splited").getItem(6))
)

# 필요 없는 컬럼 정리
df = df.drop('adid_details').drop('splited')
exploded_df = exploded_df.drop("splited").drop("ad_id_details")

result = exploded_df.join(df, 'adid', 'left')
result = result.withColumn(
    'date',
    F.date_format(F.lit(datetime.strptime(partition_dt, '%Y%m%d').date()), 'yyyy/MM/dd')
)
print(result.show())
print(result.count())
result.write.mode("overwrite").partitionBy("date").parquet(s3_output_path)
