// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Stream",
    products: [
        .library(name: "Stream", targets: ["Stream"])
    ],
    dependencies: [
        .package(path: "../Test")
    ],
    targets: [
        .target(
            name: "Stream"),
        .testTarget(
            name: "StreamTests",
            dependencies: ["Stream", "Test"])
    ]
)
