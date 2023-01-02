#!/usr/bin/env bash

# Create the Rust project and add the necessary dependencies
./create.sh || exit 1

# Build the project
./build.sh || exit 1

# Run the project in dev mode
./run-dev.sh || exit 1

# Start the server
./start.sh || exit 1
