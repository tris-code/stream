import PackageDescription

let package = Package(
    name: "Stream",
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/test.git", majorVersion: 0),
    ]
)
