// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Clang",
    products: [
      .library(name: "Clang", targets: ["Clang"])
    ],
    dependencies: [
      .package(url: "https://github.com/llvm-swift/cclang", from: "0.0.1")
    ],
    targets: [
      .target(name: "Clang"),
      .testTarget(name: "ClangTests",
                  dependencies: ["Clang"])
    ]
)
