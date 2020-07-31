import Vapor
import FluentPostgresDriver
import Fluent

public func configure(_ app: Application) throws {
    
    switch app.environment {
    case .production:
        break
    case .development:
        //Configure DB
        app.databases.use(.postgres(hostname: "localhost", port: 5432, username: "cartisim", password: "password", database: "receiptapp"), as: .psql)
        
        //Configure Middleware
        let corsConfiguration = CORSMiddleware.Configuration(allowedOrigin: .all, allowedMethods: [.GET, .PUT, .POST, .DELETE, .PATCH, .OPTIONS], allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin])
        let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
        app.middleware = .init()
        app.middleware.use(corsMiddleware)
//        app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
        break
    default:
        break
    }
    try migrations(app)
    try routes(app)
    try services(app)
    print(app.routes.all)
}
