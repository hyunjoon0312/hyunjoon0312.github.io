#!/bin/bash

# Configuration
LOG_DIR="/var/log/hadoop-hdfs/audit"
LOGFILE="/var/log/hadoop-hdfs/audit/hdfs-audit-retention.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Start log
echo "[$DATE] Start: HDFS Audit log retention task" >> "$LOGFILE"

# Compress: uncompressed logs older than 1 day
echo "[$DATE] Searching for uncompressed logs older than 1 day..." >> "$LOGFILE"
find "$LOG_DIR" -name 'hdfs-audit.log.20*' -type f -mtime +0 ! -name '*.gz' | while read -r file; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Compressing: $file" >> "$LOGFILE"
  gzip "$file" >> "$LOGFILE" 2>&1
done

# Delete: compressed logs older than 5 days
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching for compressed logs older than 5 days to delete..." >> "$LOGFILE"
find "$LOG_DIR" -name 'hdfs-audit.log.20*.gz' -type f -mtime +5 | while read -r file; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Deleting: $file" >> "$LOGFILE"
  rm -f "$file" >> "$LOGFILE" 2>&1
done

# End log
DATE_END=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$DATE_END] Completed: HDFS Audit log retention task" >> "$LOGFILE"
echo "------------------------------------------------------------" >> "$LOGFILE"