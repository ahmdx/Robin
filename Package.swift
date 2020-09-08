// swift-tools-version:5.1

import PackageDescription

let package = Package(
        name: "Robin",
        platforms: [
            .iOS(.v10)
        ],
        products: [
            .library(name: "Robin", targets: ["Robin"])
        ],
        targets: [
            .target(name: "Robin", path: "Robin")
        ],
        swiftLanguageVersions: [.v5])