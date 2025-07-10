// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SQLCipherPackage",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "SQLCipherPackage", targets: ["SQLCipherPackage"])
    ],
    targets: [
        // Binary OpenSSL dependency from GitHub release
        .binaryTarget(
            name: "OpenSSL",
            url: "https://github.com/ios-poc/OpenSSL/releases/download/0.0.3/OpenSSL.xcframework.zip",
            checksum: "e143ad5e86fd0bfc0352e5f831536b709cad47628b1e8689ce18dc0a4931e762"
        ),

        // C target wrapping SQLCipher + OpenSSL
        .target(
            name: "CSQLCipher",
            dependencies: ["OpenSSL"],
            path: "Sources/CSQLCipher",
            publicHeadersPath: "include",
            cSettings: [
                .define("SQLITE_HAS_CODEC"),
                .define("SQLCIPHER_TEST"),
                .define("SQLITE_TEMP_STORE", to: "2"),
                .define("SQLITE_EXTRA_INIT", to: "sqlcipher_extra_init"),
                .define("SQLITE_EXTRA_SHUTDOWN", to: "sqlcipher_extra_shutdown")
            ]
        ),

        // Swift wrapper
        .target(
            name: "SQLCipherPackage",
            dependencies: ["CSQLCipher"],
            path: "Sources/SQLCipherPackage"
        ),

        // Tests
        .testTarget(
            name: "SQLCipherPackageTests",
            dependencies: ["SQLCipherPackage"],
            path: "Tests/SQLCipherPackageTests"
        )
    ]
)

