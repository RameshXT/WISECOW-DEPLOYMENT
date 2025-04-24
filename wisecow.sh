#!/usr/bin/bash

SRVPORT=4499
RSPFILE=$(mktemp)
cleanup() {
    rm -f "$RSPFILE"
}

trap cleanup EXIT

get_api() {
    read line
    echo "$line"
}

handleRequest() {
    mod=$(fortune)

    cat <<EOF > "$RSPFILE"
HTTP/1.1 200 OK

<pre>$(cowsay "$mod")</pre>
EOF
}

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 || 
        { 
            echo "Install prerequisites."
            exit 1
        }
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    while true; do
        cat "$RSPFILE" | nc -lN "$SRVPORT" | handleRequest
        sleep 0.01
    done
}

main
