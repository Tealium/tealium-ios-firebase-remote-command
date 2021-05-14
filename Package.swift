// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TealiumFirebase",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "TealiumFirebase", targets: ["TealiumFirebase"])
    ],
    dependencies: [
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", from: "2.3.0"),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "TealiumFirebase",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "TealiumCore", package: "TealiumSwift"),
                .product(name: "TealiumCollect", package: "TealiumSwift"),
                .product(name: "TealiumRemoteCommands", package: "TealiumSwift"),
                .product(name: "TealiumTagManagement", package: "TealiumSwift")
            ],
            path: "./Sources"),
        .testTarget(
            name: "TealiumFirebaseTests",
            dependencies: ["TealiumFirebase"],
            path: "./Tests")
    ]
)