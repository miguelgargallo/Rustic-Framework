./update-dependencies.sh && ./create-web.sh && cargo run ./main.rs
#!/bin/bash

# Set the -e flag to exit immediately if any command returns a non-zero exit code
set -e

# Run the create-web.sh script to create the project and generate the main.rs file
./create-web.sh

# Run the update-dependencies.sh script to update the dependencies in the Cargo.toml file
./update-dependencies.sh

# Run the main-rs-maker.sh script to create the main.rs file
./main-rs-maker.sh

# Navigate to the project directory and start the web server
cd "$PROJECT_NAME"
cargo run
