// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Trigger",
    products: [
        .library(
            name: "Trigger", targets: ["Trigger"])
    ],
    targets: [
        .target( name: "Trigger"),
        .testTarget( name: "TriggerTests", dependencies: ["Trigger"])
    ]
)
