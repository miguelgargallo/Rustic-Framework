
extern crate actix_web;

use actix_web::{App, HttpServer, Result};
use actix_web::http::Method;
use actix_web::middleware::Logger;
use actix_web::web::{self, resource};

fn index() -> Result<web::HttpResponse> {
    Ok(web::HttpResponse::build(200)
        .content_type("text/html")
        .body("<h1>Hello, World!</h1>"))
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
    })
    .bind("127.0.0.1:3000")?
    .run()
}

