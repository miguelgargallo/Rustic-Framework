#!/bin/bash

# Create a new Rust project
cargo new web_project

# Change into the project directory
cd web_project

# Add the necessary dependencies
cargo add actix-web
cargo add serde

# Create the necessary project files
touch src/main.rs
touch src/lib.rs

# Add a simple "Hello, World!" server to main.rs
echo "
fn main() {
    use actix_web::{web, App, HttpResponse, HttpServer};

    async fn index() -> HttpResponse {
        HttpResponse::Ok().body("Hello, World!")
    }

    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(index))
    })
    .bind("0.0.0.0:8080")
    .unwrap()
    .run()
    .await
}
" >>src/main.rs

# Build and run the project
cargo run
