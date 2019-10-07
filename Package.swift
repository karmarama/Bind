// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bind",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "Bind", targets: ["Bind"])
    ],
    targets: [
        .target( name: "Bind"),
        .testTarget( name: "BindTests", dependencies: ["Bind"])
    ],
    swiftLanguageVersions: [.v5]
)
