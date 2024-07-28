#!/bin/bash

# Define variables
SOURCE_DIR="/path/to/source"
DEST_DIR="/path/to/destination"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="backup-$TIMESTAMP.tar.gz"

# Create the backup
tar -czf $DEST_DIR/$BACKUP_FILE $SOURCE_DIR

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup succeeded: $DEST_DIR/$BACKUP_FILE"
else
  echo "Backup failed"
fi
