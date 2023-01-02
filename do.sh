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
" >>Cargo.toml

# Create a file `src/main.rs` with the code for the web server
echo 'fn main() -> std::io::Result<()> {
    env_logger::init();
    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(|| HttpResponse::Ok().body("<h1>Hello World</h1>")))
    })
    .bind("127.0.0.1:3000")?
    .run()
}' >src/main.rs

# Build and run the server
cargo build
cargo run
