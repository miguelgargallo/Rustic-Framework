#!/usr/bin/env bash

echo "Select a port number:"
echo "1. Legacy default (3000)"
echo "2. Pylar port (3003)"
echo "3. Tradition 8080 port"
echo "4. Other (specify)"
read -p "Enter a number (1-4): " choice

case $choice in
1)
    port=3000
    ;;
2)
    port=3003
    ;;
3)
    port=8080
    ;;
4)
    read -p "Enter a port number: " port
    ;;
esac

# Start the server on the specified port
cargo run -- --port $port
