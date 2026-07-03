// swift-tools-version: 6.0
import Foundation
import PackageDescription

// Default: resolve from the published GitHub repo, pinned to a released version — always prod-ready.
// Monorepo developers opt in explicitly to build against the sibling folder on disk instead:
//   export PKS_LOCAL_PACKAGES=1
private let useLocalPackages = ProcessInfo.processInfo.environment["PKS_LOCAL_PACKAGES"] == "1"

private func pksDependency(folder: String, repo: String, from version: String) -> Package.Dependency {
    useLocalPackages
        ? .package(path: "../\(folder)")
        : .package(url: "https://github.com/POIKUS-LLC/\(repo).git", .upToNextMinor(from: Version(version)!))
}

let package = Package(
    name: "PKSCoreUI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "PKSCoreUI", targets: ["PKSCoreUI"]),
        .library(name: "PKSCoreUITestSupport", targets: ["PKSCoreUITestSupport"]),
    ],
    dependencies: [
        pksDependency(folder: "pkscore", repo: "PKSCore", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "PKSCoreUI",
            dependencies: [
                .product(name: "PKSCore", package: "pkscore")
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "PKSCoreUITestSupport",
            dependencies: ["PKSCoreUI"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "PKSCoreUITests",
            dependencies: ["PKSCoreUI", "PKSCoreUITestSupport"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
