LOCAL_PATH="/mnt/data" # EBS primary additional volume
LOG_FILE_PATH="$LOCAL_PATH/log"
HADOOP_BASE_PATH="/user/hadoop"
HADOOP_EXTRACTED_PATH="$HADOOP_BASE_PATH/extracted"

# Upload to hdfs
hadoop fs -mkdir -p $HADOOP_EXTRACTED_PATH > $LOG_FILE_PATH/log.txt 2>&1
hadoop fs -put $LOCAL_PATH/*.gz $HADOOP_EXTRACTED_PATH > $LOG_FILE_PATH/log.txt 2>&1
cat $LOG_FILE_PATH/log.txt