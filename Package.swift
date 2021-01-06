// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "Sms77Client",
        products: [
            .library(
                    name: "Sms77Client",
                    targets: ["Sms77Client"]),
        ],
        dependencies: [],
        targets: [
            .target(
                    name: "Sms77Client",
                    dependencies: []),
            .testTarget(
                    name: "Sms77ClientTests",
                    dependencies: ["Sms77Client"]),
        ]
)
