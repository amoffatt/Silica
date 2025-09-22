// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "WindowController",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        // Use local path during development
        .package(path: "../")
        // Or use Git URL for production:
        // .package(url: "https://github.com/yourusername/Silica.git", branch: "master")
    ],
    targets: [
        .executableTarget(
            name: "WindowController",
            dependencies: ["Silica"]),
    ]
)