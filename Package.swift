// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "multi-task",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)],
    products: [
        .library(name: "MultiTask", targets: ["MultiTask"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MultiTask",
            dependencies: []),
        .testTarget(
            name: "MultiTaskTests",
            dependencies: ["MultiTask"]),
    ]
)
