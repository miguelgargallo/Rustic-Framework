use actix_web::{web, App, HttpServer, Result};
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
