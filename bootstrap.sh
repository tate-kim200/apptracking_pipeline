
# copy tar file rawdata in s3 to emr instance
#DATE = $1      # in prod
DATE="20240901" # test
OBJ_URI="s3://dmp-onestore-ap-northeast-1/app_tracking_v2_tar/AppTracking_V2.$DATE.tar"
LOCAL_PATH="/mnt/data" # EBS primary additional volume
LOG_FILE_PATH="$LOCAL_PATH/log"
HADOOP_BASE_PATH="/user/hadoop"
#HADOOP_RAW_PATH="$HADOOP_BASE_PATH/raw_data"
HADOOP_EXTRACTED_PATH="$HADOOP_BASE_PATH/extracted"

mkdir $LOCAL_PATH
mkdir $LOG_FILE_PATH

## deprecated - s3 to hdfs with s3-dist-cp cmd
#S3DISTCP_CMD="s3-dist-cp --src=$OBJ_URI --dest=hdfs://$HADOOP_RAW_PATH"
#UNTAR_IN_HDFS_CMD="hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
#  -input $HADOOP_RAW_PATH/AppTracking_V2.$DATE.tar \
#  -output $HADOOP_EXTRACTED_PATH \
#  -mapper tar -xvf - \
#  -reducer /bin/cat"

## s3 to primary node ec2
S3_CP_CMD="aws s3 cp $OBJ_URI $LOCAL_PATH"
$S3_CP_CMD > $LOG_FILE_PATH/log.txt 2>&1
cat $LOG_FILE_PATH/log.txt

# un-archive tar file
UNTAR_CMD="tar -xvf $LOCAL_PATH/*.tar -C $LOCAL_PATH"
$UNTAR_CMD > $LOG_FILE_PATH/log.txt 2>&1
cat $LOG_FILE_PATH/log.txt

# Upload to hdfs
#hadoop fs -mkdir -p $HADOOP_EXTRACTED_PATH > $LOG_FILE_PATH/log.txt 2>&1
hadoop fs -put $LOCAL_PATH/*.gz $HADOOP_BASE_PATH > $LOG_FILE_PATH/log.txt 2>&1
cat $LOG_FILE_PATH/log.txt
