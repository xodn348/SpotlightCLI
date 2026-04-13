// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SpotlightCLI",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "SpotlightCLI",
            path: "Sources/SpotlightCLI"
        ),
        .testTarget(
            name: "SpotlightCLITests",
            dependencies: [],
            path: "Tests/SpotlightCLITests"
        ),
    ]
)
