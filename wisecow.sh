#!/bin/bash

# Print a message using figlet and cowsay
echo "Launching Wisecow app..." | figlet | cowsay

# Start a simple HTTP server on port 4499 to keep the container running
echo "Wisecow server is running on port 4499"
python3 -m http.server 4499
