// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Health2u",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "Health2u", targets: ["Health2u"])],
    targets: [
        .target(name: "Health2u", path: "Sources/Health2u"),
        .testTarget(name: "Health2uTests", dependencies: ["Health2u"], path: "Tests/Health2uTests"),
    ]
)
