#Task1

To develop a system health monitoring script for a Linux system, we need to check several system metrics: CPU usage, memory usage, disk space, and running processes. If any of these metrics exceed predefined thresholds, the script should send an alert.

Here's a sample Python script that performs these checks and logs alerts if any of the thresholds are exceeded:

### Python Script: `system_health_monitor.py`

```python
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
```

### Explanation

1. **Dependencies**: This script uses the `psutil` library to gather system information. Install it using pip if you haven't already:

    ```bash
    pip install psutil
    ```

2. **Logging Configuration**: The `logging` module is used to log alerts to a file (`system_health.log`). Adjust the log file path if necessary.

3. **Thresholds**: Set the thresholds for CPU usage, memory usage, and disk usage as needed. You can adjust these values based on your requirements.

4. **Check Functions**:
    - **CPU Usage**: Uses `psutil.cpu_percent()` to get the CPU usage percentage.
    - **Memory Usage**: Uses `psutil.virtual_memory()` to get the memory usage percentage.
    - **Disk Usage**: Uses `psutil.disk_usage()` to get the disk usage percentage.
    - **Running Processes**: Checks for processes with high CPU usage (e.g., processes using more than 10% CPU).

5. **Alerts**: If any metric exceeds its threshold, the script prints an alert message to the console and logs it to `system_health.log`.

### Running the Script

To run the script, save it as `system_health_monitor.py` and execute it from the command line:

```bash
python system_health_monitor.py
```

### Notes

- **Permissions**: Ensure you have the necessary permissions to access system metrics and processes.
- **Custom Thresholds**: You may want to customize the thresholds and the criteria for monitoring running processes based on your specific use case.
- **Log File Location**: Adjust the logging configuration if you need the log file to be stored in a different location.

#task2

Creating a script to analyze web server logs can help you identify common patterns and issues. Below is a sample Python script that analyzes Apache or Nginx web server logs for several common patterns. The script will generate a report summarizing:

1. Number of 404 errors.
2. Most requested pages.
3. IP addresses with the most requests.

### Python Script: `log_analyzer.py`

```python
import re
from collections import Counter

# Regular expressions for parsing common log formats
APACHE_LOG_PATTERN = r'(?P<ip>\S+) \S+ \S+ \[.*?\] "(?P<method>\S+) (?P<page>\S+) \S+" (?P<status>\d{3})'
NGINX_LOG_PATTERN = r'(?P<ip>\S+) \S+ \S+ \[.*?\] "(?P<method>\S+) (?P<page>\S+) \S+" (?P<status>\d{3})'

def parse_log_line(line, pattern):
    """Parse a single line of the log file."""
    match = re.match(pattern, line)
    if match:
        return match.groupdict()
    return None

def analyze_logs(log_file_path, log_type='apache'):
    """Analyze the log file and output a summarized report."""
    if log_type == 'apache':
        pattern = APACHE_LOG_PATTERN
    elif log_type == 'nginx':
        pattern = NGINX_LOG_PATTERN
    else:
        raise ValueError("Unsupported log type. Choose 'apache' or 'nginx'.")

    status_counter = Counter()
    page_counter = Counter()
    ip_counter = Counter()

    with open(log_file_path, 'r') as file:
        for line in file:
            parsed_line = parse_log_line(line, pattern)
            if parsed_line:
                status_code = parsed_line.get('status')
                page = parsed_line.get('page')
                ip = parsed_line.get('ip')

                if status_code:
                    status_counter[status_code] += 1
                if page:
                    page_counter[page] += 1
                if ip:
                    ip_counter[ip] += 1

    # Print summarized report
    print("Log Analysis Report:")
    print("====================")

    # Number of 404 errors
    print(f"404 Errors: {status_counter.get('404', 0)}")

    # Most requested pages
    print("\nMost Requested Pages:")
    for page, count in page_counter.most_common(10):
        print(f"{page}: {count} requests")

    # IP addresses with the most requests
    print("\nIP Addresses with Most Requests:")
    for ip, count in ip_counter.most_common(10):
        print(f"{ip}: {count} requests")

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Analyze web server logs for common patterns.")
    parser.add_argument('log_file', help="Path to the log file to analyze")
    parser.add_argument('--type', choices=['apache', 'nginx'], default='apache', help="Type of log file (apache or nginx)")
    args = parser.parse_args()

    analyze_logs(args.log_file, args.type)
```

### How to Use the Script

1. **Save the script** as `log_analyzer.py`.

2. **Run the script** from the command line, providing the path to your log file and optionally specifying the log type (`apache` or `nginx`). For example:

    ```bash
    python log_analyzer.py /path/to/access.log --type apache
    ```

    or

    ```bash
    python log_analyzer.py /path/to/access.log --type nginx
    ```

### Explanation

- **Regular Expressions**: The `APACHE_LOG_PATTERN` and `NGINX_LOG_PATTERN` are regular expressions used to parse lines in Apache and Nginx log formats, respectively. You may need to adjust these patterns based on the exact format of your logs.

- **Parsing**: The `parse_log_line` function uses the regular expression to extract relevant information from each line of the log file.

- **Counters**: The `status_counter`, `page_counter`, and `ip_counter` counters keep track of occurrences of status codes, requested pages, and IP addresses.

- **Report**: The script outputs a report with the number of 404 errors, the most requested pages, and IP addresses with the most requests.

### Notes

- **Log Formats**: Ensure that the log patterns match the format of your server logs. Adjust the regular expressions if needed.
- **File Path**: Replace `/path/to/access.log` with the actual path to your log file.

