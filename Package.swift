// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransitionPhaseAnimator",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "TransitionPhaseAnimator",
            targets: ["TransitionPhaseAnimator"]),
    ],
    targets: [
        .target(
            name: "TransitionPhaseAnimator"),
        .testTarget(
            name: "TransitionPhaseAnimatorTests",
            dependencies: ["TransitionPhaseAnimator"]),
    ]
)
