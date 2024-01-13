// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "features",
    platforms: [
        .iOS(.v17),
        .macOS(.v10_13),
    ],
    products: [
        .singleTargetLibrary("TodoInterface"),
        .singleTargetLibrary("TodoUI"),
    ],
    targets: [
        .target(
            name: "TodoInterface"
        ),
        .target(
            name: "TodoUI",
            dependencies: [
                "TodoInterface"
            ]
        ),
        .testTarget(
            name: "TodoTests",
            dependencies: [
                "TodoInterface"
            ]
        ),
    ]
)

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
