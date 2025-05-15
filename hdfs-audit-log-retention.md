/var/log/hadoop-hdfs/audit/hdfs-audit-retention.log {
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
    copytruncate
}