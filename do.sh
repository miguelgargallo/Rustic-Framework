#!/usr/bin/env bash

# Install Rust if it is not already installed
if ! command -v rustc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Create a new Rust project
cargo new --bin rust-webserver
cd rust-webserver

# Add the following dependencies to the project's `Cargo.toml` file:
# actix-web = "2.0"
# env_logger = "0.7"

# Create a file `src/main.rs` with the following contents:
echo 'use actix_web::{web, App, HttpResponse, HttpServer};
use env_logger;

#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    env_logger::init();
    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(|| HttpResponse::Ok().body("<h1>Hello World</h1>")))
    })
    .bind("127.0.0.1:3000")?
    .run()
    .await
}' >src/main.rs

# Build and run the server
cargo build
cargo run
