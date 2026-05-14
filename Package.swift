// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BabyKeys",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "BabyKeys",
            path: "Sources/BabyKeys",
            resources: [.copy("Resources/AppIcon.icns")]
        )
    ]
)
