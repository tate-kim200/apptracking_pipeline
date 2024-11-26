
# copy tar file rawdata in s3 to emr instance
#DATE = $1      # in prod
DATE="20240901" # test
OBJ_URI="s3://dmp-onestore-ap-northeast-1/app_tracking_v2_tar/AppTracking_V2.$DATE.tar"
LOCAL_PATH="/mnt/data" # EBS primary additional volume
LOG_FILE_PATH="$LOCAL_PATH/log"

mkdir $LOCAL_PATH
mkdir $LOG_FILE_PATH

## s3 to primary node ec2
S3_CP_CMD="aws s3 cp $OBJ_URI $LOCAL_PATH"
$S3_CP_CMD > $LOG_FILE_PATH/log.txt 2>&1
cat $LOG_FILE_PATH/log.txt

# un-archive tar file
UNTAR_CMD="tar -xvf $LOCAL_PATH/*.tar -C $LOCAL_PATH"
$UNTAR_CMD > $LOG_FILE_PATH/log.txt 2>&1
cat $LOG_FILE_PATH/log.txt