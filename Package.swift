// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SystemImagePicker",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "SystemImagePicker",
            targets: ["SystemImagePicker"]
        )
    ],
    targets: [
        .target(
            name: "SystemImagePicker",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SystemImagePickerTests",
            dependencies: ["SystemImagePicker"],
            resources: [.process("Resources")]
        )
    ]
)
