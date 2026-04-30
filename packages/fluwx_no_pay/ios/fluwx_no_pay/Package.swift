// swift-tools-version: 5.9
import PackageDescription

// ✅ 无任何外部依赖 — WechatOpenSDK 完全不链接
// binary 通过 CI nm 检查验证无微信 SDK 符号
let package = Package(
    name: "fluwx_no_pay",
    platforms: [.iOS("12.0")],
    products: [
        .library(name: "fluwx-no-pay", targets: ["fluwx_no_pay"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "fluwx_no_pay",
            dependencies: [],
            path: "Sources/fluwx_no_pay",   // → symlink → _shared/ios/Sources
            publicHeadersPath: "include",
            resources: [
            ],
            cSettings: [
                .define("FLUWX_NO_PAY"),
                .headerSearchPath("include")
            ],
            swiftSettings: [
                .define("FLUWX_NO_PAY")
            ],
            linkerSettings: [
                .linkedFramework("CoreGraphics"),
                .linkedFramework("Security"),
                .linkedFramework("WebKit")
            ]
            // ⚠️ 无 -ObjC -all_load：没有静态 SDK 需要强制加载
        )
    ]
)
