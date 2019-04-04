// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Stream",
    products: [
        .library(name: "Stream", targets: ["Stream"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/test.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "Stream"),
        .testTarget(
            name: "StreamTests",
            dependencies: ["Stream", "Test"])
    ]
)
