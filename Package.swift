// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// sdk-version:1.1.0
let package = Package(
    name: "TwitchSDK",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TwitchSDK",
            targets: ["TwitchAuth", "TwitchChat", "TwitchCommon"])
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", .upToNextMajor(from: "4.0.6")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TwitchCommon",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Starscream", package: "Starscream")
            ]
        ),
        .target(
            name: "TwitchAuth",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .target(name: "TwitchCommon")
            ]
        ),
        .target(
            name: "TwitchChat",
            dependencies: [
                .target(name: "TwitchCommon"),
                .product(name: "Alamofire", package: "Alamofire")
            ]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
