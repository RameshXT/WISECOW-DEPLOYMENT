import requests
import time
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

URL = "https://52.87.224.35:4499/"
TIMEOUT = 5
LOG_FILE = "health-check.log"

def log_message(message):
    print(message)
    with open(LOG_FILE, "a") as f:
        f.write(message + "\n")

try:
    response = requests.get(URL, timeout=TIMEOUT, verify=False)
    if response.status_code == 200:
        log_message(f"[{time.ctime()}] Application is UP")
    else:
        log_message(f"[{time.ctime()}] Application is DOWN. Status Code: {response.status_code}")
except requests.exceptions.RequestException as e:
    log_message(f"[{time.ctime()}] Application is DOWN. Error: {e}")
