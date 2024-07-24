#!/bin/bash

SOURCE_DIR="/home/adminuser508/mongodb"
DEST_DIR="/home/ubuntu"
REMOTE_USER="ubuntu"
REMOTE_HOST="10.220.108.174"  
LOG_FILE="$HOME/logfile.log"
KEY_FILE="/home/adminuser508/Desktop/shared/nsl-shared.pem"  
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

echo "[$TIMESTAMP] Starting backup of $SOURCE_DIR to $REMOTE_USER@$REMOTE_HOST:$DEST_DIR" >> $LOG_FILE

rsync -avz -e "ssh -i $KEY_FILE" --delete $SOURCE_DIR $REMOTE_USER@$REMOTE_HOST:$DEST_DIR &>> $LOG_FILE

if [ $? -eq 0 ]; then
     echo "[$TIMESTAMP] Backup successful." >> $LOG_FILE
	    else
     echo "[$TIMESTAMP] Backup failed." >> $LOG_FILE
fi
 cat $LOG_FILE



