#!/bin/bash

# Set the -e flag to exit immediately if any command returns a non-zero exit code
set -e

# Set the default port number
PORT=3000

# Parse command-line options
while getopts ":p:" opt; do
    case $opt in
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

# Prompt the user for the project name
read -p "Enter a name for the project: " PROJECT_NAME

# Check if the project directory already exists
if [ -d "$PROJECT_NAME" ]; then
    read -p "Directory '$PROJECT_NAME' already exists. Do you want to overwrite it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    rm -rf "$PROJECT_NAME"
fi

# Create the project directory and navigate to it
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Run the update-dependencies.sh script to generate the Cargo.toml file
./update-dependencies.sh

# Create a src/main.rs file with a simple web server
echo 'use actix_web::{web, App, HttpServer, Result};
use env_logger;
use log::info;

async fn index() -> Result<web::HttpResponse> {
    info!("Request received for '/'");
    Ok(web::HttpResponse::build(200)
        .content_type("text/html")
        .body("<h1>Hello, World!</h1>"))
}

async fn default() -> Result<web::HttpResponse> {
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
            .default_service(web::resource("").route(web::get().to(default)))
    })
    .bind(format!("127.0.0.1:{}", PORT))?
    .run()
}
' >src/main.rs
