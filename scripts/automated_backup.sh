#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Get system health metrics
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_USAGE=$(df -h / | grep / | awk '{ print $5}' | sed 's/%//g')
RUNNING_PROCESSES=$(ps aux | wc -l)

# Check CPU usage
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
  echo "CPU usage is above threshold: $CPU_USAGE%"
fi

# Check memory usage
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
  echo "Memory usage is above threshold: $MEMORY_USAGE%"
fi

# Check disk usage
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
  echo "Disk usage is above threshold: $DISK_USAGE%"
fi

# Output running processes
echo "Number of running processes: $RUNNING_PROCESSES"
