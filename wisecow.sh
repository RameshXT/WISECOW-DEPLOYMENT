#!/usr/bin/env bash

PORT=4499

prerequisites() {
	command -v cowsay >/dev/null 2>&1 && command -v fortune >/dev/null 2>&1 || {
		echo "Missing dependencies!"
		exit 1
	}
}

handle_connection() {
	while true; do
		{
			echo -e "HTTP/1.1 200 OK\r"
			echo -e "Content-Type: text/html\r\n"
			echo "<pre>"
			cowsay "$(fortune)"
			echo "</pre>"
		} | nc -l -p "$PORT" -N
	done
}

main() {
	prerequisites
	echo "🚀 Serving wisdom at http://localhost:$PORT"
	handle_connection
}

main
