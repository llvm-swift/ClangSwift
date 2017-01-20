import PackageDescription

let package = Package(
    name: "Clang",
    dependencies: [
      .Package(url: "https://github.com/trill-lang/cclang", majorVersion: 0)
    ]
)
