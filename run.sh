#!/bin/bash

# Start the web server in the background
cargo run &

# Wait for the server to start
sleep 5

# Open the default web browser to the site
xdg-open "http://0.0.0.0:8080"
