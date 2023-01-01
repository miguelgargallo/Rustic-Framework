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

# Ask the user for the package name and version
read -p "Enter the package name: " name
read -p "Enter the package version: " version

# Check if Cargo.toml already exists
if [[ -f "Cargo.toml" ]]; then
    read -p "Cargo.toml already exists. Do you want to overwrite it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    rm "Cargo.toml"
fi

# Extract the dependencies from main.rs
dependencies=$(grep '^extern crate' main.rs | cut -d' ' -f3)

# Write the package information and dependencies to Cargo.toml
echo '[package]' >Cargo.toml
echo "name = \"$name\"" >>Cargo.toml
echo "version = \"$version\"" >>Cargo.toml
echo 'edition = "2021"' >>Cargo.toml
echo '' >>Cargo.toml
echo '[dependencies]' >>Cargo.toml

# Get the latest versions of the dependencies
for dep in $dependencies; do
    version=$(cargo search "$dep" | grep "$dep" | head -1 | cut -d' ' -f2)
    echo "$dep = \"$version\"" >>Cargo.toml
done
