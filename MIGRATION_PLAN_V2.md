# fluwx：CocoaPods → Swift Package Manager 迁移方案 v2

> **no_pay 仅针对 iOS**，Android / HarmonyOS 两端两个包行为完全一致，均完整引入微信 SDK。
> 本方案在原始草案基础上修订，消除了 Android 差异化配置的多余复杂度，补全了 ohos 层、
> PrivacyInfo.xcprivacy、iOS 宏名迁移、wechat_setup.rb 替代方案等遗漏项。

---

## 目录

1. [背景与约束](#1-背景与约束)
2. [架构决策](#2-架构决策)
3. [最终架构](#3-最终架构)
4. [目录结构](#4-目录结构)
5. [Monorepo 管理（Melos）](#5-monorepo-管理melos)
6. [代码共享机制](#6-代码共享机制)
7. [iOS SPM 配置](#7-ios-spm-配置)
8. [iOS 宏名迁移](#8-ios-宏名迁移)
9. [Android 配置](#9-android-配置)
10. [HarmonyOS 配置](#10-harmonyos-配置)
11. [Dart 层](#11-dart-层)
12. [版本管理与发布流程](#12-版本管理与发布流程)
13. [CI/CD](#13-cicd)
14. [用户迁移指引](#14-用户迁移指引)
15. [里程碑计划](#15-里程碑计划)
16. [风险与局限](#16-风险与局限)

---

## 1. 背景与约束

### 现状

| 项目 | 现状 |
|------|------|
| 当前版本 | `6.0.0-preview.3` |
| iOS 依赖管理 | CocoaPods，`pay` subspec 依赖 `WechatOpenSDK-XCFramework ~> 2.0.5`，`no_pay` subspec 依赖 `OpenWeChatSDKNoPay ~> 2.0.5` |
| no_pay 切换方式 | 用户在 `pubspec.yaml` 设置 `fluwx.ios.no_pay: true`，Ruby 脚本 `wechat_setup.rb` 动态切换 podspec subspec |
| iOS 宏 | 现有代码使用 `#ifndef NO_PAY` |
| Android | 始终完整引入微信 SDK，无 no_pay 概念 |
| HarmonyOS | 已有完整 ohos 实现，无 no_pay 概念 |
| 平台支持 | iOS / Android / HarmonyOS |

### 硬性约束

- **支付合规**：`fluwx_no_pay` 的 iOS binary 中**不能出现** WechatOpenSDK 的任何符号
- **零代码重复**：三个平台的原生代码只维护一份
- **过渡期兼容**：CocoaPods 用户不能立刻断掉，两套并行直到 Flutter 官方弃用 CocoaPods
- **Android / ohos 不受影响**：两个包的 Android 和 ohos 实现完全相同

---

## 2. 架构决策

SPM 的依赖声明是静态的，发生在 Flutter 工具链介入之前，因此无法像 CocoaPods 那样在 install 阶段动态切换 subspec。唯一满足 iOS 合规的方案是**两个独立 pub 包**：

| 包名 | iOS | Android | HarmonyOS |
|------|-----|---------|-----------|
| `fluwx` | 链接 WechatOpenSDK | 完整微信 SDK | 完整微信 SDK |
| `fluwx_no_pay` | 完全不链接任何微信 SDK | 完整微信 SDK（与 fluwx 相同） | 完整微信 SDK（与 fluwx 相同） |

两个包通过 **symlink + Gradle source sets + ohos source 引用** 共享全部原生代码，零重复。

---

## 3. 最终架构

```
┌──────────────────────────────────────────────────────────────┐
│                      fluwx-monorepo                          │
│                                                              │
│  packages/                                                   │
│  ├── _shared/              ← 原生代码唯一真相来源             │
│  │   ├── ios/Sources/      ← iOS ObjC（一份）                 │
│  │   ├── android/          ← Android Kotlin（一份）           │
│  │   └── ohos/             ← HarmonyOS ArkTS（一份）          │
│  │                                                           │
│  ├── fluwx/                ← pub 包（iOS 含支付）             │
│  │   ├── ios/fluwx/                                          │
│  │   │   ├── Package.swift      依赖 WechatOpenSDK SPM wrapper│
│  │   │   │                      定义 FLUWX_WITH_PAY          │
│  │   │   └── Sources/fluwx/ → symlink → _shared/ios/Sources  │
│  │   ├── android/          → source set → _shared/android    │
│  │   └── ohos/             → 引用 _shared/ohos               │
│  │                                                           │
│  └── fluwx_no_pay/         ← pub 包（iOS 无支付）            │
│      ├── ios/fluwx_no_pay/                                   │
│      │   ├── Package.swift      无任何 SDK 依赖               │
│      │   │                      定义 FLUWX_NO_PAY            │
│      │   └── Sources/ → symlink → _shared/ios/Sources        │
│      ├── lib/              → symlink → ../fluwx/lib           │
│      ├── android/          → source set → _shared/android    │
│      └── ohos/             → 引用 _shared/ohos               │
└──────────────────────────────────────────────────────────────┘
```

**iOS 编译时行为对比（同一份源码，根据宏产生不同 binary）：**

```objc
#ifdef FLUWX_WITH_PAY
    // fluwx 包：链接 WechatOpenSDK，编译支付代码
    PayReq *req = [[PayReq alloc] init];
    [WXApi sendReq:req completion:...];
#endif

#ifdef FLUWX_NO_PAY
    // fluwx_no_pay 包：WechatOpenSDK 完全不存在
    result(FlutterMethodNotImplemented);
#endif
```

---

## 4. 目录结构

```
fluwx-monorepo/
├── melos.yaml
├── pubspec.yaml                       # Workspace 根（仅 dev 依赖）
├── tools/
│   └── sync_version.dart              # 版本同步脚本
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── publish.yml
│
└── packages/
    │
    ├── _shared/                       # ⚠️ 非 pub 包，不发布
    │   ├── ios/
    │   │   └── Sources/               # iOS 原生源码（唯一副本）
    │   │       ├── include/
    │   │       │   ├── FluwxPlugin.h
    │   │       │   └── FluwxDelegate.h
    │   │       ├── FluwxPlugin.m
    │   │       ├── FluwxDelegate.m
    │   │       ├── FluwxStringUtil.h / .m
    │   │       ├── NSStringWrapper.h / .m
    │   │       ├── ThumbnailHelper.h / .m
    │   │       └── Resources/
    │   │           └── PrivacyInfo.xcprivacy
    │   │
    │   ├── android/                   # Android 原生源码（唯一副本）
    │   │   └── src/main/kotlin/com/jarvan/fluwx/
    │   │       ├── FluwxPlugin.kt
    │   │       ├── FluwxFileProvider.kt
    │   │       ├── handlers/
    │   │       ├── io/
    │   │       ├── utils/
    │   │       └── wxapi/
    │   │
    │   └── ohos/                      # HarmonyOS 原生源码（唯一副本）
    │       └── src/main/ets/components/plugin/
    │           ├── FluwxPlugin.ets
    │           └── handlers/
    │
    ├── fluwx/
    │   ├── pubspec.yaml               # version: 6.x.x
    │   ├── CHANGELOG.md
    │   ├── lib/                       # Dart 源码
    │   ├── android/
    │   │   ├── build.gradle           # source set 指向 _shared/android
    │   │   └── src/main/AndroidManifest.xml
    │   ├── ohos/
    │   │   └── oh-package.json5       # source 引用 _shared/ohos
    │   └── ios/
    │       ├── fluwx.podspec          # 保留，含 WechatOpenSDK 依赖（过渡期）
    │       └── fluwx/
    │           ├── Package.swift
    │           └── Sources/fluwx/    → symlink → ../../../_shared/ios/Sources
    │
    └── fluwx_no_pay/
        ├── pubspec.yaml               # version: 与 fluwx 保持一致
        ├── CHANGELOG.md
        ├── lib/                      → symlink → ../fluwx/lib
        ├── android/
        │   ├── build.gradle           # 与 fluwx 完全相同
        │   └── src/main/AndroidManifest.xml
        ├── ohos/
        │   └── oh-package.json5
        └── ios/
            ├── fluwx_no_pay.podspec   # 保留，无 SDK 依赖（过渡期）
            └── fluwx_no_pay/
                ├── Package.swift
                └── Sources/fluwx_no_pay/ → symlink → ../../../_shared/ios/Sources
```

---

## 5. Monorepo 管理（Melos）

```yaml
# melos.yaml
name: fluwx_workspace

packages:
  - packages/fluwx
  - packages/fluwx_no_pay
  - "!packages/_shared"        # _shared 不是 pub 包，排除

command:
  version:
    linkToCommits: true
    updateGitTagRefs: true
    workspaceChangelog: true

scripts:
  analyze:
    run: flutter analyze
    exec:
      concurrency: 1

  test:
    run: flutter test
    exec:
      concurrency: 2

  version:sync:
    run: dart tools/sync_version.dart
    description: "同步 fluwx_no_pay 版本与 fluwx 一致"

  pod:lint:
    run: pod lib lint ios/$MELOS_PACKAGE_NAME.podspec --skip-tests --use-modular-headers
    exec:
      concurrency: 1
    packageFilters:
      fileExists: "ios/*.podspec"

  publish:all:
    run: melos publish --no-dry-run --yes
```

---

## 6. 代码共享机制

### iOS：symlink

```bash
# 建立 symlink（一次性，提交到 git）

# fluwx
ln -sf ../../../../_shared/ios/Sources \
    packages/fluwx/ios/fluwx/Sources/fluwx

# fluwx_no_pay
ln -sf ../../../../_shared/ios/Sources \
    packages/fluwx_no_pay/ios/fluwx_no_pay/Sources/fluwx_no_pay

# Dart 层共享
ln -sf ../fluwx/lib \
    packages/fluwx_no_pay/lib
```

> **Windows 开发者**：`git config core.symlinks true`
>
> `dart pub publish` 发布时自动解析 symlink 打包真实文件，pub.dev 上两个包各自完整独立。

### Android：Gradle source sets

两个包的 `build.gradle` **完全相同**，都指向 `_shared/android`，都完整引入微信 SDK：

```groovy
// packages/fluwx/android/build.gradle
// packages/fluwx_no_pay/android/build.gradle  ← 内容完全一样
android {
    sourceSets {
        main {
            java.srcDirs += ['../../_shared/android/src/main/kotlin']
        }
    }
}
dependencies {
    api 'com.tencent.mm.opensdk:wechat-sdk-android:6.8.34'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.10.2'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2'
    implementation 'id.zelory:compressor:3.0.1'
    implementation 'com.squareup.okhttp3:okhttp:5.2.1'
}
```

`generateFluwxHelperFile`（生成 `FluwxConfigurations.kt`）任务各自保留在两个包的 `build.gradle` 中，逻辑完全相同。

### HarmonyOS：oh-package.json5 source 引用

```json5
// packages/fluwx/ohos/oh-package.json5
// packages/fluwx_no_pay/ohos/oh-package.json5  ← 内容完全一样
{
  "name": "fluwx",  // fluwx_no_pay 包改为对应名字
  "main": "../../../_shared/ohos/index.ets"
}
```

---

## 7. iOS SPM 配置

### fluwx/ios/fluwx/Package.swift（含支付）

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "fluwx",
    platforms: [.iOS("12.0")],
    products: [
        .library(name: "fluwx", targets: ["fluwx"])
    ],
    dependencies: [
        // 推荐自托管 wrapper（见下文说明）
        .package(
            url: "https://github.com/YOUR_ORG/WechatOpenSDK-SPM.git",
            from: "2.0.5"
        )
    ],
    targets: [
        .target(
            name: "fluwx",
            dependencies: [
                .product(name: "WechatOpenSDK", package: "WechatOpenSDK-SPM")
            ],
            path: "Sources/fluwx",
            publicHeadersPath: "include",
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("FLUWX_WITH_PAY")
            ],
            cSettings: [
                .define("FLUWX_WITH_PAY"),
                .headerSearchPath("include")
            ],
            linkerSettings: [
                .unsafeFlags(["-ObjC", "-all_load"])
            ]
        )
    ]
)
```

### fluwx_no_pay/ios/fluwx_no_pay/Package.swift（无支付）

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "fluwx_no_pay",
    platforms: [.iOS("12.0")],
    products: [
        .library(name: "fluwx-no-pay", targets: ["fluwx_no_pay"])
    ],
    dependencies: [],    // ✅ 完全没有外部依赖
    targets: [
        .target(
            name: "fluwx_no_pay",
            dependencies: [],
            path: "Sources/fluwx_no_pay",
            publicHeadersPath: "include",
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("FLUWX_NO_PAY")
            ],
            cSettings: [
                .define("FLUWX_NO_PAY"),
                .headerSearchPath("include")
            ]
            // ⚠️ 无 -ObjC -all_load，没有静态 SDK 需要加载
        )
    ]
)
```

### WechatOpenSDK SPM Wrapper

腾讯官方不提供 SPM 包，**必须自托管**：

1. 下载腾讯官方 `WechatOpenSDK-XCFramework 2.0.5`
2. 参考 `yanyin1986/WechatOpenSDK` 结构，在自己的 GitHub org 建仓库
3. `Package.swift` 里用 `.binaryTarget` 指向 XCFramework，填写正确的 `checksum`
4. 在 `fluwx/ios/fluwx/Package.swift` 中指向自托管地址

自托管的好处是版本完全自控，不依赖第三方维护节奏。

---

## 8. iOS 宏名迁移

### 问题

现有代码使用 `#ifndef NO_PAY`（共 4 处），新方案改为语义更清晰的正向宏 `FLUWX_WITH_PAY` / `FLUWX_NO_PAY`。

### 迁移方式

```objc
// 旧写法
#ifndef NO_PAY
    [WXApi sendReq:...];
#endif

// 新写法（等价，语义更清晰）
#ifdef FLUWX_WITH_PAY
    [WXApi sendReq:...];
#endif
```

全局替换规则：`#ifndef NO_PAY` → `#ifdef FLUWX_WITH_PAY`，`#ifdef NO_PAY` → `#ifdef FLUWX_NO_PAY`。

### CI 符号表验证（必须加）

仅靠代码审查无法保证合规，CI 里需要对 `fluwx_no_pay` 的产物做符号表检查：

```bash
# ci.yml 新增步骤：验证 fluwx_no_pay binary 中无 WechatOpenSDK 符号
- name: Verify no WechatOpenSDK symbols in fluwx_no_pay
  run: |
    BINARY=$(find ~/Library/Developer/Xcode/DerivedData -name "fluwx_no_pay" -type f | head -1)
    if nm "$BINARY" | grep -q "WX\|WechatOpenSDK"; then
      echo "❌ fluwx_no_pay binary contains WechatOpenSDK symbols!"
      exit 1
    fi
    echo "✅ Binary is clean"
```

---

## 9. Android 配置

**两个包 Android 配置完全一致，均完整引入微信 SDK，无任何差异化处理。**

每个包的 `android/` 目录只保留：
- `build.gradle`：source set 指向 `_shared/android`，包含 `generateFluwxHelperFile` 任务
- `src/main/AndroidManifest.xml`：包名对应各自包

`_shared/android/` 里的所有 Kotlin 代码无需任何条件宏，维持现有逻辑不变。

---

## 10. HarmonyOS 配置

**两个包 ohos 配置完全一致，均完整引入微信 SDK，无任何差异化处理。**

```
packages/
├── _shared/ohos/          ← 从现有 fluwx/ohos/ 迁入，内容不变
│   └── src/main/ets/components/plugin/
│       ├── FluwxPlugin.ets
│       └── handlers/
│
├── fluwx/ohos/            → oh-package.json5 引用 _shared/ohos
└── fluwx_no_pay/ohos/     → oh-package.json5 引用 _shared/ohos（内容相同）
```

---

## 11. Dart 层

Dart 层通过 symlink 完全共享，`lib/` 下均为相对 import，发布后不存在 `package:` 引用冲突：

```bash
ln -sf ../fluwx/lib packages/fluwx_no_pay/lib
```

`fluwx_no_pay` 用户调用支付接口时，iOS native 返回 `notImplemented`，Dart 侧抛出 `MissingPluginException`，不会静默失败。

---

## 12. 版本管理与发布流程

### 版本同步脚本

```dart
// tools/sync_version.dart
import 'dart:io';

void main(List<String> args) {
  final fluwxPubspec  = File('packages/fluwx/pubspec.yaml');
  final noPayPubspec  = File('packages/fluwx_no_pay/pubspec.yaml');

  final content = fluwxPubspec.readAsStringSync();
  final match   = RegExp(r'^version:\s*(.+)$', multiLine: true).firstMatch(content);
  if (match == null) { print('❌ 未找到版本号'); exit(1); }
  final version = match.group(1)!.trim();

  var noPayContent = noPayPubspec.readAsStringSync();
  noPayContent = noPayContent.replaceFirstMapped(
    RegExp(r'^version: .+$', multiLine: true),
    (_) => 'version: $version',
  );
  noPayPubspec.writeAsStringSync(noPayContent);
  print('✅ fluwx_no_pay 版本已同步至 $version');

  // --check 模式：只校验不写入（供 CI 用）
  if (args.contains('--check')) {
    final noPayVersion = RegExp(r'^version:\s*(.+)$', multiLine: true)
        .firstMatch(noPayPubspec.readAsStringSync())?.group(1)?.trim();
    if (noPayVersion != version) {
      print('❌ 版本不同步：fluwx=$version, fluwx_no_pay=$noPayVersion');
      exit(1);
    }
    print('✅ 版本一致');
  }
}
```

### 发布步骤

```bash
# 1. 修改 packages/fluwx/pubspec.yaml 版本号
# 2. 同步版本
dart tools/sync_version.dart
# 3. 更新两个包的 CHANGELOG
# 4. 提交并打 tag
git add .
git commit -m "chore: release v6.x.x"
git tag v6.x.x
git push origin main --tags
# 5. CI 自动发布（或手动执行）
melos publish --no-dry-run --yes
```

**发布顺序**：先发 `fluwx`，再发 `fluwx_no_pay`。

---

## 13. CI/CD

### ci.yml

```yaml
name: CI
on:
  pull_request:
    branches: [main]

jobs:
  analyze_test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: stable

      - name: Install Melos
        run: dart pub global activate melos

      - name: Bootstrap
        run: melos bootstrap

      - name: Analyze
        run: melos run analyze

      - name: Test
        run: melos run test

      - name: Verify symlinks
        run: |
          test -L packages/fluwx_no_pay/lib || exit 1
          test -L packages/fluwx/ios/fluwx/Sources/fluwx || exit 1
          test -L packages/fluwx_no_pay/ios/fluwx_no_pay/Sources/fluwx_no_pay || exit 1
          echo "✅ 所有 symlink 完好"

      - name: Pod lint
        run: melos run pod:lint

      - name: Build fluwx_no_pay iOS (SPM)
        run: |
          cd packages/fluwx_no_pay/example
          flutter build ios --no-codesign

      - name: Verify no WechatOpenSDK symbols in fluwx_no_pay
        run: |
          BINARY=$(find ~/Library/Developer/Xcode/DerivedData \
            -name "fluwx_no_pay" -type f 2>/dev/null | head -1)
          if [ -z "$BINARY" ]; then
            echo "⚠️  Binary not found，跳过符号检查"
            exit 0
          fi
          if nm "$BINARY" | grep -qE "WX[A-Z]|WechatOpenSDK"; then
            echo "❌ fluwx_no_pay binary 中发现 WechatOpenSDK 符号！"
            exit 1
          fi
          echo "✅ Binary 无微信 SDK 符号"
```

### publish.yml

```yaml
name: Publish
on:
  push:
    tags:
      - 'v*'

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dart-lang/setup-dart@v1

      - name: Install Melos
        run: dart pub global activate melos

      - name: Bootstrap
        run: melos bootstrap

      - name: Verify version sync
        run: dart tools/sync_version.dart --check

      - name: Setup pub credentials
        run: |
          mkdir -p ~/.config/dart
          echo '${{ secrets.PUB_CREDENTIALS }}' > ~/.config/dart/pub-credentials.json

      - name: Publish
        run: melos publish --no-dry-run --yes
```

---

## 14. 用户迁移指引

### 含支付用户（无需换包名）

```yaml
# pubspec.yaml
dependencies:
  fluwx: ^6.0.0    # 版本号更新即可，SPM 自动生效
```

开启 SPM（Flutter 3.24+）：
```bash
flutter config --enable-swift-package-manager
```

**手动配置 Xcode（替代原 wechat_setup.rb 的工作）**：

SPM 模式下 `wechat_setup.rb` 不再自动运行，需要手动在 Xcode 里完成：

1. 在 `Info.plist` 添加 `LSApplicationQueriesSchemes`，包含 `weixin`、`weixinULAPI`
2. 在 `Info.plist` 添加 `CFBundleURLTypes`，URL Scheme 填写微信 AppID
3. 在项目 Capabilities 开启 `Associated Domains`，填写 Universal Link 域名
4. 在 `AppDelegate` 中接入 `handleOpenURL` 和 `continueUserActivity`

> CocoaPods 用户不开启 SPM 则 `wechat_setup.rb` 继续生效，无需任何改动。

### 无支付用户（需换包名）

```yaml
# pubspec.yaml
dependencies:
  fluwx_no_pay: ^6.0.0    # 换包名，删除原 fluwx.ios.no_pay 配置
```

```dart
// Dart import 换一行，其余代码完全不变
// 以前
import 'package:fluwx/fluwx.dart';
// 现在
import 'package:fluwx_no_pay/fluwx.dart';
```

### 继续使用 CocoaPods（暂不迁移）

两个包在过渡期同时保留 podspec，不开启 SPM 的项目行为与之前完全一致。

---

## 15. 里程碑计划

```
阶段 0：前置重构（1 周，在现有单包上操作）
  □ 将 ios/Classes/ 内容迁移到 packages/_shared/ios/Sources/
  □ 将 android/src/ 内容迁移到 packages/_shared/android/
  □ 将 ohos/src/ 内容迁移到 packages/_shared/ohos/
  □ 将 iOS 宏名从 NO_PAY → FLUWX_WITH_PAY / FLUWX_NO_PAY 全局替换
  □ 验证单包（fluwx）仍可正常构建

阶段 1：Monorepo 搭建（1 周）
  □ 建立 packages/ 目录结构
  □ 建立所有 symlink
  □ 配置 melos.yaml
  □ 验证 fluwx 和 fluwx_no_pay 可独立 flutter run

阶段 2：SPM 支持（3 周）
  □ 自托管 WechatOpenSDK SPM wrapper，生成正确的 checksum
  □ 编写 fluwx Package.swift（含 PrivacyInfo 资源、FLUWX_WITH_PAY 宏）
  □ 编写 fluwx_no_pay Package.swift（含 PrivacyInfo 资源、FLUWX_NO_PAY 宏）
  □ 验证含支付版本 SPM 构建通过
  □ 验证无支付版本 binary 中无 WechatOpenSDK 符号（nm 检查）
  □ CocoaPods 路径同时保留，双轨验证

阶段 3：CI/CD + 发布（1 周）
  □ 配置 ci.yml（含 symlink 校验 + 符号表检查）
  □ 配置 publish.yml
  □ 版本同步脚本测试
  □ dry-run 发布验证
  □ v6.0.0 正式发布

阶段 4：过渡期运营（持续）
  - 监控用户反馈
  - 等待 Flutter 官方弃用 CocoaPods 通知
  - 届时移除所有 podspec，发布 v7.0.0 纯 SPM 版本
```

---

## 16. 风险与局限

| 风险 | 严重程度 | 说明 | 缓解措施 |
|------|---------|------|---------|
| WechatOpenSDK 无官方 SPM 包 | 高 | 需自托管 XCFramework wrapper | 自托管，版本完全自控 |
| ARM64 模拟器不支持 | 中 | XCFramework 不含 `ios-arm64-simulator` slice | 开发调试用真机，CI 用真机 |
| Windows 开发者 symlink 问题 | 中 | Windows 默认不支持 symlink | 文档说明，CI 校验 symlink 完整性 |
| `-ObjC -all_load` unsafeFlags | 低 | SPM 的 unsafeFlags 在非 root package 有限制 | 已有社区广泛先例，可接受 |
| CocoaPods 弃用时间未知 | 低 | Flutter 官方路线图已明确，时间不确定 | 双轨并行，随时可切断 |
| wechat_setup.rb 无 SPM 等价 | 低 | SPM 用户需手动配置 Xcode | 迁移文档详细说明，影响范围可控 |
