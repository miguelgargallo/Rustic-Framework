#!/bin/bash

# Set the -e flag to exit immediately if any command returns a non-zero exit code
set -e

# Check if Rust and Cargo are installed
if ! command -v rustc >/dev/null; then
    echo "Error: Rust is not installed."
    exit 1
fi

if ! command -v cargo >/dev/null; then
    echo "Error: Cargo is not installed."
    exit 1
fi

# Create an empty Cargo.toml file
echo '[package]
name = "my-web-app"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]' >Cargo.toml

# Extract the dependencies from the main.rs file
grep -E '^use\s+[^:]+:' main.rs |
    sed 's/^use\s*\([^:]*\):.*/\1/' |
    while read -r dependency; do
        # Get the latest version of the dependency
        version=$(cargo search "$dependency" | grep "$dependency" | head -n 1 | cut -d ' ' -f 2)
        # Add the dependency to the Cargo.toml file
        echo "$dependency = \"$version\"" >>Cargo.toml
    done
