// swift-tools-version: 5.9
import PackageDescription

// ✅ 无任何外部依赖 — WechatOpenSDK 完全不链接
// binary 通过 CI nm 检查验证无微信 SDK 符号
//
// ⚠️  PrivacyInfo.xcprivacy 说明：
//    - CocoaPods：由 podspec 的 resource_bundles 自动打包，无需额外操作
//    - SPM：Flutter ephemeral 不支持 resources: 参数，需在 app Xcode 工程的
//           TARGETS → Build Phases → Copy Bundle Resources 中手动添加
//           packages/_shared/ios/Sources/Resources/PrivacyInfo.xcprivacy
let package = Package(
    name: "fluwx_no_pay",
    platforms: [.iOS("12.0")],
    products: [
        .library(name: "fluwx-no-pay", targets: ["fluwx_no_pay"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/JarvanMo/WechatOpenSDK-NoPay-SPM", //
            from: "2.0.5"
        )
    ],
    targets: [
        .target(
            name: "fluwx_no_pay",
            dependencies: [],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
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
