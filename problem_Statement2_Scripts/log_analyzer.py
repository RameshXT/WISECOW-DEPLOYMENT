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
