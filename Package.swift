// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "receipts",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "receipts", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.14.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.1.0")
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
            ]
        
        ),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

