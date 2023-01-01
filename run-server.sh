#!/bin/bash

# Change to the project directory
cd /my-web-app

# Set the -e flag to exit immediately if any command returns a non-zero exit code
set -e

# Define a variable for the port number
PORT=3000

# Parse command-line options
while getopts ":p:" opt; do
    case $opt in
    p)
        PORT=$OPTARG
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done

# Start the web server
cargo run -- --port $PORT
