// swift-tools-version:5.5
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
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", .upToNextMajor(from: "2.6.0")),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "9.1.0"))
    ],
    targets: [
        .target(
            name: "TealiumFirebase",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "TealiumCore", package: "TealiumSwift"),
                .product(name: "TealiumRemoteCommands", package: "TealiumSwift")
            ],
            path: "./Sources",
            exclude: ["Support"]),
        .testTarget(
            name: "TealiumFirebaseTests",
            dependencies: ["TealiumFirebase"],
            path: "./Tests",
            exclude: ["Support"])
    ]
)
