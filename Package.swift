// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LightsparkWallet",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LightsparkWallet",
            targets: ["LightsparkWallet"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(name: "lightspark_cryptoFFI",
                      url: "https://github.com/lightsparkdev/lightspark-crypto-uniffi/releases/download/0.1.0/lightspark-cryptoFFI.xcframework.zip",
                      checksum: "e3e79e6590a5d3856181eea9e1bb70a4a5fbbc8200fd9b0c9193b1e7df4f2959"),
        .target(
            name: "LightsparkWallet",
            dependencies: ["lightspark_cryptoFFI"]
        ),
        .testTarget(
            name: "LightsparkWalletTests",
            dependencies: ["LightsparkWallet"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
