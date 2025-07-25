#!/bin/bash

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

LOG_FILE="system-health.log"
touch $LOG_FILE

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_INT=${CPU_USAGE%.*}

MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')

DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

PROC_COUNT=$(ps -e --no-headers | wc -l)

echo "===== $(date) =====" >> $LOG_FILE
if [ "$CPU_INT" -gt "$CPU_THRESHOLD" ]; then
    echo "High CPU usage: $CPU_USAGE%" >> $LOG_FILE
fi

if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    echo "High Memory usage: $MEM_USAGE%" >> $LOG_FILE
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "High Disk usage: $DISK_USAGE%" >> $LOG_FILE
fi

echo "Running processes: $PROC_COUNT" >> $LOG_FILE
echo "" >> $LOG_FILE
