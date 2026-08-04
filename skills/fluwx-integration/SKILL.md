---
name: fluwx-integration
description: 在 Flutter App 中接入微信 SDK 插件 fluwx / fluwx_no_pay（v6+）的完整指南：微信分享（会话/朋友圈/收藏）、微信登录（获取 auth code）、微信支付、拉起小程序、订阅消息、微信客服、H5 拉起 App，以及 Android / iOS / OpenHarmony 的平台配置与排错。只要在 Flutter 项目里涉及微信相关功能——分享到微信、微信授权登录、WeChat Pay、universal link、LSApplicationQueriesSchemes、errCode -1、无法拉起微信等——即使用户没有点名 fluwx，也应使用本 skill。
---

# fluwx 接入指南

fluwx 是微信开放平台原生 SDK 的 Flutter 插件。本 skill 基于 **v6**（破坏性大版本），如果项目里已经在用 v4/v5，先读[迁移说明](#从旧版本迁移)。

## 第一步：选包

| 包 | 适用场景 |
|---|---|
| `fluwx` | 需要微信支付 |
| `fluwx_no_pay` | 不需要支付。二进制中不含任何微信支付符号，**用于通过 App Store 审核**（部分类目 App 携带支付符号会被拒） |

两个包 Dart API 完全相同，切换只需改依赖名和 import。如果 App 明确不做微信支付且要上架 App Store，直接用 `fluwx_no_pay`。

```bash
flutter pub add fluwx        # 或 flutter pub add fluwx_no_pay
```

用 `flutter pub add` 或到 pub.dev 查最新版本号，不要凭记忆写死版本。

## 第二步：微信开放平台前置条件

接入前用户必须在[微信开放平台](https://open.weixin.qq.com/)创建移动应用并拿到：

1. **AppID**（`wx` 开头）。
2. **Android 应用签名**：与包名绑定。签名是 keystore MD5 **去掉冒号/横杠并全部小写**。debug 和 release 签名不同——平台上填的是哪个，另一个环境就会调不起微信（`errCode: -1` 最常见的原因）。用微信官方[签名工具](https://open.weixin.qq.com/zh_CN/htmledition/res/dev/download/sdk/Gen_Signature_Android.apk)生成最保险。
3. **iOS Universal Link**：一个你控制的 https 域名，托管 `apple-app-site-association` 文件。平台上填写的必须与 App 配置一致。

如果这些还没准备好，先提醒用户去开放平台配置，代码写完也调不通。

## 第三步：初始化

```dart
import 'package:fluwx/fluwx.dart'; // no_pay 则为 package:fluwx_no_pay/fluwx_no_pay.dart

final fluwx = Fluwx();
await fluwx.registerApi(
  appId: "wxd930ea5d5a228f5f",
  universalLink: "https://your.example.com/app/", // 仅 iOS 需要
);
```

- 越早注册越好（通常在 `main()` 或首页 initState）。重复注册无害。
- iOS 上 `registerApi` 返回 false / -1：检查 AppID 与 universal link 是否与开放平台一致。
- debug 阶段 iOS 可调用 `await fluwx.selfCheck()`（仅 debug 生效）自检配置。

可选的 `pubspec.yaml` 配置（v6 起**只对 Android 生效**，iOS 配置必须手动做，见下一步）：

```yaml
fluwx:
  debug_logging: true            # 可选；目前 iOS 上无效果
  android:
    flutter_activity: MainActivity  # 可选；冷启动回调找不到入口时配置
    interrupt_wx_request: true      # 可选；默认 true，由 fluwx 拦截处理微信请求
```

## 第四步：平台配置

### iOS（v6 必须全部手动配置）

v6 起 SDK 不再自动处理 URL scheme / universal link / 白名单，旧版本写在 `pubspec.yaml` 里的 iOS 配置**全部失效**。需要在 Runner 的 `Info.plist` 加：

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>weixin</string>
  <string>weixinULAPI</string>
  <string>weixinURLParamsAPI</string>
</array>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>weixin</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>wxd930ea5d5a228f5f</string><!-- 就是你的微信 AppID -->
    </array>
  </dict>
</array>
```

再在 Xcode 的 Signing & Capabilities 添加 **Associated Domains**：`applinks:your.example.com`，并确保该域名根目录（或 `.well-known/`）能通过 https 访问到 `apple-app-site-association`。

- v6 同时支持 AppDelegate 与 SceneDelegate（`FlutterSceneDelegate`）两种生命周期，也同时支持 CocoaPods 与 Swift Package Manager，不需要在 AppDelegate 里手动转发 openURL / continueUserActivity。
- Universal link 自测方法：把链接写进备忘录点击，能跳转 Safari 且顶部提示打开 App 即为配置正确。

### Android

基本零配置：`WXEntryActivity`、FileProvider 都由插件提供，不要自己再注册（手动注册过的旧项目要检查 Manifest 包名是否写对）。注意两点：

- 开启混淆时按微信官方要求 keep SDK 类：
  ```proguard
  -keep class com.tencent.mm.opensdk.** { *; }
  -keep class com.tencent.wxop.** { *; }
  -keep class com.tencent.mm.sdk.** { *; }
  ```
- 调不起微信几乎都是**签名与开放平台不一致**，见第二步。

### OpenHarmony

检查微信是否安装需要在 `module.json5` 中声明：

```json5
{ "module": { "querySchemes": ["weixin"] } }
```

调试时不要用 IDE 自动签名，需手动申请调试证书签名。

## 核心心智模型：回调是订阅式的

`share` / `pay` / `authBy` 等方法的 `Future<bool>` 返回值只是原生 `sendRequest` 是否发出去了，**不是业务结果**。真实结果通过订阅获取：

```dart
late final FluwxCancelable cancelable;

@override
void initState() {
  super.initState();
  cancelable = fluwx.addSubscriber((response) {
    switch (response) {
      case WeChatAuthResponse(:final code, :final errCode) when errCode == 0:
        // 把 code 交给后端换 access_token，完成登录
      case WeChatPaymentResponse(:final errCode):
        // 0 成功；-2 用户取消；-1 看 troubleshooting
      case WeChatShareResponse():
        // 注意：微信已不再区分“分享成功”和“取消分享”，一律返回成功
      default:
    }
  });
}

@override
void dispose() {
  cancelable.cancel(); // 必须取消，否则回调会重复触发
  super.dispose();
}
```

errCode 通用含义：`0` 成功；`-2` 用户取消；`-4` 拒绝授权；`-1` 通用错误（原因极多，九成是 AppID/签名/universal link 配置问题）。

## 常用功能速查

完整参数与全部类型见 [references/api.md](references/api.md)。注意 v6 的模型与网上旧教程不同：缩略图统一是 `thumbData: Uint8List`（不再有 `WeChatImage`），图片本体用 `WeChatImageToShare`。

```dart
// 分享文本 / 网页（scene: session 会话 / timeline 朋友圈 / favorite 收藏）
fluwx.share(WeChatShareTextModel("text", scene: WeChatScene.session));
fluwx.share(WeChatShareWebPageModel("https://…", title: "标题", thumbData: bytes));

// 分享图片：iOS 只认 uint8List；Android 可用本地路径
fluwx.share(WeChatShareImageModel(
  WeChatImageToShare(uint8List: imageBytes),
  title: "标题",
));

// 分享小程序卡片
fluwx.share(WeChatShareMiniProgramModel(
  webPageUrl: "https://…", userName: "gh_xxx", path: "/pages/index",
  title: "标题", thumbData: bytes,
));

// 微信登录：只负责拿 code，用 code 换 token/用户信息应由后端完成
fluwx.authBy(which: NormalAuth(scope: 'snsapi_userinfo', state: 'your_state'));

// 微信支付：参数逐字来自后端统一下单接口，客户端绝不自己拼签名
fluwx.pay(which: Payment(
  appId: r['appid'], partnerId: r['partnerid'], prepayId: r['prepayid'],
  packageValue: r['package'], nonceStr: r['noncestr'],
  timestamp: r['timestamp'], sign: r['sign'],
));

// 拉起小程序 / 打开微信客服
fluwx.open(target: MiniProgram(username: "gh_xxx", path: "/pages/index"));
fluwx.open(target: CustomerServiceChat(corpId: "ww…", url: "https://work.weixin.qq.com/kfid/…"));
```

**iOS 审核红线**：使用任何微信功能前先 `await fluwx.isWeChatInstalled`，未安装微信时必须隐藏微信相关入口，否则 App Store 审核会以"未安装微信时功能不可用"拒审。

## H5 / 小程序拉起 App（冷启动）

微信开放标签 `<wx-open-launch-app>` 或小程序拉起 App 后，通过订阅收事件：Android 收到 `WeChatShowMessageFromWXRequest`，iOS 收到 `WeChatLaunchFromWXRequest`，两个都要处理。冷启动场景在注册后调用 `fluwx.attemptToResumeMsgFromWx()`，主动取值用 `fluwx.getExtMsg()`。Android 冷启动回调异常时配置 pubspec 的 `flutter_activity`。

## 从旧版本迁移

v4/v5 → v6 的破坏点集中在 iOS：pubspec 里的 iOS 配置全部失效，URL scheme、universal link、`LSApplicationQueriesSchemes` 必须按第四步手动配置；新增 SceneDelegate 与 SPM 支持。Android 无变化。

## 出问题了？

按 [references/troubleshooting.md](references/troubleshooting.md) 排查，覆盖：拉不起微信、errCode -1、`isWeChatInstalled` 返回 false、支付回调收不到、与 Dio 的 `ResponseType` 命名冲突、图片分享失败等高频问题。
