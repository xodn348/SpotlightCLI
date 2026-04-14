// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SpotlightCLI",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/soffes/HotKey.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "SpotlightCLI",
            dependencies: [.product(name: "HotKey", package: "HotKey")],
            path: "Sources/SpotlightCLI"
        ),
        .testTarget(
            name: "SpotlightCLITests",
            dependencies: ["SpotlightCLI"],
            path: "Tests/SpotlightCLITests"
        ),
    ]
)
