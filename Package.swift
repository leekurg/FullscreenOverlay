// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FullscreenOverlay",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "FullscreenOverlay",
            targets: ["FullscreenOverlay"]
        )
    ],
    targets: [
        .target(
            name: "FullscreenOverlay",
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        )
    ]
)
