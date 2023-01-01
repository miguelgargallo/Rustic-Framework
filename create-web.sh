#!/bin/bash

# Set the -e flag to exit immediately if any command returns a non-zero exit code
set -e

# Define variables for the project name and port number
PROJECT_NAME=my-web-app
PORT=3000

# Check if Rust and Cargo are installed
if ! command -v rustc >/dev/null; then
    echo "Error: Rust is not installed."
    exit 1
fi

if ! command -v cargo >/dev/null; then
    echo "Error: Cargo is not installed."
    exit 1
fi

# Parse command-line options
while getopts ":n:p:" opt; do
    case $opt in
    n)
        PROJECT_NAME=$OPTARG
        ;;
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

# Create a new Rust project
function create_project {
    if [[ -d "$PROJECT_NAME" ]]; then
        read -p "Directory '$PROJECT_NAME' already exists. Do you want to overwrite it? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
        rm -rf "$PROJECT_NAME"
    fi
    cargo new "$PROJECT_NAME"
}
create_project
cd "$PROJECT_NAME"

# Add Actix-web and env_logger as dependencies
echo '
        [package]
        name = "my-web-app"
        version = "0.1.0"
        edition = "2021"

        # See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

        [dependencies]
        actix-web = "2.0"
        env_logger = "0.7"
        ' >>Cargo.toml

# Create a .gitignore file
echo '
        /target
        Cargo.lock
        ' >>.gitignore

# Create a main.rs file with the following code:
echo '
        extern crate actix_web;

        use actix_web::{App, HttpServer, Result};
        use actix_web::http::Method;
        use actix_web::middleware::Logger;
        use actix_web::web::{self, resource, service};

        fn index() -> Result<web::HttpResponse> {
            Ok(web::HttpResponse::build(200)
                .content_type("text/html")
                .body("<h1>Hello, World!</h1>"))
        }

        fn default() -> Result<web::HttpResponse> {
            Ok(web::HttpResponse::build(404)
                .content_type("text/html")
                .body("<h1>404 Page Not Found</h1>"))
        }

        fn main() -> std::io::Result<()> {
    std::env::set_var("RUST_LOG", "actix_web=info");
    env_logger::init();

    HttpServer::new(|| {
        App::new()
            .wrap(Logger::default())
            .service(
                resource("/").route(web::get().to(index)),
            )
            .default_service(
                web::resource("")
                    .route(web::get().to(default))
                    .route(web::head().to(default)),
            )
    })
    .bind(format!("127.0.0.1:{}", PORT))?
    .run()
}
' >main.rs
