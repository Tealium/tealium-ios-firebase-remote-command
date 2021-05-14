// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TealiumFirebase",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "TealiumFirebase", targets: ["TealiumFirebase"])
    ],
    dependencies: [
        .package(url: "https://github.com/tealium/tealium-swift", from: "2.3.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "TealiumFirebase",
            dependencies: ["Adjust", "TealiumCore", "TealiumRemoteCommands", "TealiumTagManagement", "TealiumCollect"],
            path: "./Sources"),
        .testTarget(
            name: "TealiumFirebaseTests",
            dependencies: ["TealiumFirebase"],
            path: "./Tests")
    ]
)