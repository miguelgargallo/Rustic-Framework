#!/usr/bin/env bash

# Read the port number from the user, or use the default of 3000
read -p "Enter a port number (default: 3000): " port
port=${port:-3000}

# Start the server on the specified port
cargo run -- --port $port
