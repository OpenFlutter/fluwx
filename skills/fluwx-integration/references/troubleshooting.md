# fluwx 排错手册

按症状查找。排查任何问题前先确认三件事：AppID 正确、`registerApi` 已调用且返回 true、（iOS）universal link 与开放平台填写一致。

## 拉不起微信 / errCode: -1

`-1` 是微信 SDK 的通用错误码，原因按平台排查：

**Android：**
- 开放平台填的**应用签名**与当前构建的签名不一致。签名是 keystore MD5 去掉冒号并全部小写。
- debug 和 release 默认签名不同：用 release keystore 签名生成的签名填了平台，debug 构建就调不起（反之亦然）。要么两个环境统一 signingConfig，要么平台上填当前调试用的签名。
- 包名与开放平台不一致。
- 用微信官方"签名校验工具" App 输入包名直接生成正确签名，最不容易错。

**iOS：**
- Universal link 配置错误。自测：把链接写进备忘录点击，应跳转 Safari 且顶部提示打开 App。
- `Info.plist` 缺 `LSApplicationQueriesSchemes`（weixin / weixinULAPI / weixinURLParamsAPI）或 URL scheme 没有设置为 AppID。
- Associated Domains 没加 `applinks:域名`，或 `apple-app-site-association` 文件不可访问/内容不对（注意 CDN 缓存和 Apple 的 AASA 缓存，改完可能要等）。
- debug 模式下调 `fluwx.selfCheck()` 让 SDK 自检。

**支付场景的 -1**：如果分享能成功而支付 -1，客户端配置基本没问题，大概率是后端统一下单参数错误（最常见是后端用错了 AppID，或签名串拼装错误）。让后端核对。

## isWeChatInstalled 返回 false（微信明明装了）

- iOS：`LSApplicationQueriesSchemes` 白名单没配。
- OpenHarmony：`module.json5` 没加 `"querySchemes": ["weixin"]`。
- iOS 重写过 AppDelegate 的项目：确认没有破坏 plugin 注册。

## 回调收不到 / 收到多次

- 收到多次：`addSubscriber` 被重复注册。在 `dispose` 里 `cancelable.cancel()`，或确保只注册一次（比如放在单例里）。
- 支付完成后用户按物理返回键回到 App 时偶发收不到回调：这是已知现象，**支付结果永远以后端查单为准**，客户端回调只用于界面提示。
- H5/小程序冷启动拉起 App 收不到：注册完成后调用 `attemptToResumeMsgFromWx()`；Android 检查 pubspec 中 `fluwx.android.flutter_activity` 是否指向正确的 Activity。
- 分享后想区分"成功"还是"取消"：做不到。微信官方已调整，取消/成功统一返回成功。

## iOS 审核被拒

- **未装微信时功能不可用**：所有微信入口必须先 `isWeChatInstalled` 判断，未安装就隐藏。
- **携带支付符号被拒**（某些类目）：换 `fluwx_no_pay` 包，它的二进制不含微信支付符号。

## 编译 / 依赖问题

- **iOS deployment target 过低**：报 "required a higher minimum deployment target"，把 Podfile 的 platform 提到 fluwx 要求的版本以上再 `pod install`。
- **No such module 'fluwx'**：项目从 Android 环境挪到 iOS 时常见，重新 `flutter pub get` + `cd ios && pod install`（CocoaPods 模式），或确认 SPM 开关状态（`flutter config --enable-swift-package-manager` / `--no-...`）与项目集成方式一致。
- **与 Dio 的 `ResponseType` 命名冲突**：`import 'package:fluwx/fluwx.dart' as fluwx;` 用前缀导入。
- **与 ShareSDK 等其他微信插件冲突**：两个插件各自链接了微信 SDK 导致符号重复，需统一改为依赖同一份微信 SDK（参考对方插件文档），或去掉其中一个。
- **Android 混淆后运行时报错**：keep 微信 SDK：
  ```proguard
  -keep class com.tencent.mm.opensdk.** { *; }
  -keep class com.tencent.wxop.** { *; }
  -keep class com.tencent.mm.sdk.** { *; }
  ```

## 分享相关

- **图片分享失败**：图片本体 ≤10MB；缩略图 `thumbData` 过大是最常见原因，普通消息控制在 32KB 内、小程序 `hdImageData` 128KB 内，自己压缩后再传。
- **iOS 分享图片无反应**：iOS 必须传 `WeChatImageToShare(uint8List: ...)`，只传 `localImagePath` 无效（那是 Android-only）。
- **分享后微信提示"未审核应用"**：微信侧限制，应用还未通过开放平台审核，与 fluwx 无关。
- **崩溃（旧项目手动注册过 WXEntryActivity）**：删掉手动注册的 `WXEntryActivity` / `WXPayEntryActivity`，v6 由插件提供；保留的话检查 Manifest 里包名。

## 其他

- **Android 弹出微信分身选择**：系统多开功能的行为，与 fluwx 无关。
- **errCode -2**：用户主动取消，不是错误，不需要处理成失败提示以外的逻辑。
- 以上都排除后：查 [GitHub issues](https://github.com/OpenFlutter/fluwx/issues) 和 [官方 QA](https://github.com/OpenFlutter/fluwx/blob/main/doc/QA_CN.md)。
