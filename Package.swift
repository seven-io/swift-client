// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "SevenClient",
        products: [
            .library(
                    name: "SevenClient",
                    targets: ["SevenClient"]),
        ],
        dependencies: [],
        targets: [
            .target(
                    name: "SevenClient",
                    dependencies: []),
            .testTarget(
                    name: "SevenClientTests",
                    dependencies: ["SevenClient"]),
        ]
)
