// swift-tools-version: 5.9
import PackageDescription


let package = Package(
    name: "fluwx",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "fluwx", targets: ["fluwx"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/JarvanMo/WechatOpenSDK-SPM", //
            from: "2.0.5"
        )
    ],
    targets: [
        .target(
            name: "fluwx",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "WechatOpenSDK", package: "WechatOpenSDK-SPM")
            ],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ],
            cSettings: [
                .define("FLUWX_WITH_PAY"),
                .headerSearchPath("include")
            ],
            swiftSettings: [
                .define("FLUWX_WITH_PAY")
            ],
            linkerSettings: [
                .linkedFramework("CoreGraphics"),
                .linkedFramework("Security"),
                .linkedFramework("WebKit"),
                .unsafeFlags(["-ObjC", "-all_load"])
            ]
        )
    ]
)
