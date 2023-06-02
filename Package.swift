// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LightsparkWallet",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LightsparkWallet",
            targets: ["LightsparkWallet"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", .upToNextMajor(from: "0.11.0")),
        .package(url: "https://github.com/bitcoindevkit/bdk-swift", .upToNextMajor(from: "0.28.0")),
        .package(url: "https://github.com/keefertaylor/Base58Swift.git", from: "2.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LightsparkWallet",
            dependencies: [
                .product(name: "secp256k1", package: "secp256k1.swift"),
                .product(name: "BitcoinDevKit", package: "bdk-swift"),
                .product(name: "Base58Swift", package: "Base58Swift"),
            ]
        ),
        .testTarget(
            name: "LightsparkWalletTests",
            dependencies: ["LightsparkWallet"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
