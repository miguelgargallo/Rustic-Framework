# Rustic Framework, a Paper by Miguel Gargallo

Here is a simple example of a Rust web application that uses the Actix-web framework to serve a static HTML file:

create.sh

This script will create a new Rust project, check for the latest compatible versions of the actix-web, env_logger, and actix-rt crates, and add them to the Cargo.toml file.

```bash
#!/usr/bin/env bash

# Create a new Rust project
cargo new --bin rust-webserver
cd rust-webserver

# Check for the latest compatible versions of the `actix-web`, `env_logger`, and `actix-rt` crates
actix_web_version=$(cargo search --limit=1 actix-web | grep -oP '^actix-web\s+\K[^\s]+')
env_logger_version=$(cargo search --limit=1 env_logger | grep -oP '^env_logger\s+\K[^\s]+')
actix_rt_version=$(cargo search --limit=1 actix-rt | grep -oP '^actix-rt\s+\K[^\s]+')

# Add the necessary dependencies to the project's `Cargo.toml` file
echo "
[dependencies]
actix-web = \"$actix_web_version\"
env_logger = \"$env_logger_version\"
actix-rt = \"$actix_rt_version\"
" >> Cargo.toml
```

## build.sh

This script will build the Rust project.

```bash
#!/usr/bin/env bash

# Build the project
cargo build
```

# run-dev.sh

This script will run the Rust project in dev mode, which will automatically rebuild the project and restart the server when changes are made to the source code.

```bash
#!/usr/bin/env bash

# Run the project in dev mode
cargo watch -x run
```

# start.sh

This script will prompt the user to specify a port number for the Rust web server, or use the default of 3000 if no input is provided. The server will then be started on the specified port.

```bash
#!/usr/bin/env bash

# Read the port number from the user, or use the default of 3000
read -p "Enter a port number (default: 3000): " port
port=${port:-3000}

# Start the server on the specified port
cargo run -- --port $port
```

# do.sh

This script will run the create.sh, build.sh, and start.sh scripts in sequence.

```bash
#!/usr/bin/env bash

# Create the Rust project and add the necessary dependencies
./create.sh || exit 1

# Build the project
./build.sh || exit 1

# Run the project in dev mode
./run-dev.sh || exit 1

# Start the server
./start.sh || exit 1
```
