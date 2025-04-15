import subprocess
import psutil
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(filename='system_health.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Thresholds
CPU_THRESHOLD = 80  # in percent
MEMORY_THRESHOLD = 80  # in percent
DISK_THRESHOLD = 80  # in percent

def check_cpu_usage():
    """Check CPU usage and log an alert if it exceeds the threshold."""
    cpu_usage = psutil.cpu_percent(interval=1)
    if cpu_usage > CPU_THRESHOLD:
        message = f"High CPU usage detected: {cpu_usage}%"
        print(message)
        logging.warning(message)

def check_memory_usage():
    """Check memory usage and log an alert if it exceeds the threshold."""
    memory_info = psutil.virtual_memory()
    memory_usage = memory_info.percent
    if memory_usage > MEMORY_THRESHOLD:
        message = f"High memory usage detected: {memory_usage}%"
        print(message)
        logging.warning(message)

def check_disk_usage():
    """Check disk usage and log an alert if it exceeds the threshold."""
    disk_info = psutil.disk_usage('/')
    disk_usage = disk_info.percent
    if disk_usage > DISK_THRESHOLD:
        message = f"High disk usage detected: {disk_usage}%"
        print(message)
        logging.warning(message)

def check_running_processes():
    """Check for high CPU usage processes and log an alert."""
    process_list = []
    for proc in psutil.process_iter(['pid', 'name', 'cpu_percent']):
        try:
            cpu_usage = proc.info['cpu_percent']
            if cpu_usage > 10:  # Example threshold for process CPU usage
                process_list.append(f"{proc.info['name']} (PID: {proc.info['pid']}): {cpu_usage}%")
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            continue

    if process_list:
        message = "High CPU usage processes detected:\n" + "\n".join(process_list)
        print(message)
        logging.warning(message)

def main():
    """Main function to check system health."""
    check_cpu_usage()
    check_memory_usage()
    check_disk_usage()
    check_running_processes()

if __name__ == "__main__":
    main()
