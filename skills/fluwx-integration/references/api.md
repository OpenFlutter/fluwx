# fluwx v6 API 参考

以 v6 源码为准整理。所有类型从 `package:fluwx/fluwx.dart`（或 `package:fluwx_no_pay/fluwx_no_pay.dart`）导出。

## Fluwx 实例方法

| 方法 | 说明 |
|---|---|
| `registerApi({appId, universalLink, doOnIOS, doOnAndroid})` | 注册微信 SDK，重复调用无害；`universalLink` 仅 iOS 必填 |
| `isWeChatInstalled` (getter) | 微信是否安装；iOS 依赖 `LSApplicationQueriesSchemes`，OHOS 依赖 `querySchemes` |
| `share(WeChatShareModel what)` | 分享，见下方模型 |
| `authBy({required AuthType which})` | 登录（拿 auth code） |
| `stopAuthByQRCode()` | 停止二维码登录服务 |
| `pay({required PayType which})` | 支付（fluwx_no_pay 中 iOS 原生层无支付实现） |
| `open({required OpenType target})` | 打开微信内目标（小程序、客服、浏览器等） |
| `autoDeduct({required AutoDeduct data})` | 签约代扣（纯签约/支付中签约），参数见微信支付文档 |
| `getExtMsg()` | 获取 H5/小程序拉起 App 传入的 extinfo |
| `attemptToResumeMsgFromWx()` | 冷启动后尝试恢复微信拉起消息 |
| `selfCheck()` | 仅 iOS debug 模式：自检配置 |
| `isSupportOpenBusinessView` (getter) | 是否支持 openBusinessView |
| `addSubscriber(listener)` → `FluwxCancelable` | 订阅微信回调；用返回值 `.cancel()` 取消 |
| `removeSubscriber(listener)` / `clearSubscribers()` | 移除订阅 |

## 分享模型（WeChatShareModel）

公共可选参数（所有模型均有）：`title`、`description`、`thumbData: Uint8List?`（缩略图字节）、`thumbDataHash`、`msgSignature`。多数模型另有 `scene`（默认 `WeChatScene.session`）、`mediaTagName`、`messageAction`、`messageExt`。

缩略图大小限制来自微信 SDK：普通消息缩略图应控制在 32KB 内，小程序卡片 `hdImageData` 128KB 内，超限会分享失败或被丢弃。fluwx 会尝试压缩缩略图，但不保证效果，最好自己压好再传。

| 模型 | 关键参数 |
|---|---|
| `WeChatShareTextModel(source, {scene})` | `source` 文本内容 |
| `WeChatShareWebPageModel(webPage, {title, description, thumbData, scene})` | 网页链接 |
| `WeChatShareImageModel(source, {title, scene, entranceMiniProgramUsername, entranceMiniProgramPath})` | `source` 为 `WeChatImageToShare`，图片本体 ≤10MB |
| `WeChatShareMiniProgramModel({webPageUrl, userName, path, title, thumbData, hdImageData, miniProgramType, withShareTicket})` | 小程序卡片；仅支持分享到会话；`hdImageData` 仅 iOS |
| `WeChatShareMusicModel({musicUrl, musicDataUrl, musicLowBandUrl, title, description})` | 音乐 |
| `WeChatShareVideoModel({videoUrl, videoLowBandUrl, title, description})` | 视频 |
| `WeChatShareFileModel(source, {title})` | 文件 |
| `WeChatShareEmojiModel(source)` | 表情 |

```dart
enum WeChatScene { session, timeline, favorite } // 会话 / 朋友圈 / 收藏
enum WXMiniProgramType { release, test, preview }
```

### WeChatImageToShare

```dart
WeChatImageToShare({Uint8List? uint8List, String? localImagePath, String? imgDataHash})
```

- `uint8List`：iOS、Android 都可用；**iOS 上必须提供**。
- `localImagePath`：仅 Android；`content://` 开头按 ContentProvider 处理（需已有读取权限），两者都传时优先 `uint8List`。

> v6 不再有旧版的 `WeChatImage.network/file/asset/binary`，网上旧教程里的写法已失效。

## AuthType（登录）

| 类型 | 参数 | 说明 |
|---|---|---|
| `NormalAuth` | `scope`（必填，常用 `snsapi_userinfo`）、`state`、`nonAutomatic` | 拉起微信 App 授权，回调 `WeChatAuthResponse.code` |
| `QRCode` | `appId, scope, nonceStr, timestamp, signature, schemeData(仅iOS)` | 未装微信时扫码登录；配合 `WeChatAuthGotQRCodeResponse` / `WeChatQRCodeScannedResponse` / `WeChatAuthByQRCodeFinishedResponse` |
| `PhoneLogin` | `scope, state` | 仅 iOS |

拿到 `code` 后换 access_token 与用户信息应在后端完成，fluwx 不提供也不建议客户端做。

## PayType（支付）

| 类型 | 参数 |
|---|---|
| `Payment` | `appId, partnerId, prepayId, packageValue, nonceStr, timestamp(int), sign`，可选 `signType, extData` |
| `HongKongWallet` | `prepayId` |

全部参数逐字来自后端统一下单返回，`packageValue` 对应接口里的 `package` 字段（通常是 `Sign=WXPay`）。

## OpenType（open 的目标）

| 类型 | 参数 |
|---|---|
| `WeChatApp` | 无（只是打开微信） |
| `Browser` | `url` |
| `MiniProgram` | `username`（gh_ 开头原始 ID）、`path`、`miniProgramType` |
| `CustomerServiceChat` | `corpId`（ww 开头企业 ID）、`url`（客服链接） |
| `SubscribeMessage` | `appId, scene, templateId, reserved`（一次性订阅消息） |
| `BusinessView` | `businessType, query` |
| `Invoice` | `appId, cardType, locationId, cardId, canMultiSelect` |
| `RankList` | 无 |

## WeChatResponse（回调类型）

基类字段：`errCode: int?`、`errStr: String?`、`isSuccessful`（`errCode == 0`）。

| 类型 | 额外字段 | 触发场景 |
|---|---|---|
| `WeChatShareResponse` | `type` | 分享返回（成功/取消已不可区分） |
| `WeChatAuthResponse` | `code, state, country, lang` | 登录授权返回 |
| `WeChatPaymentResponse` | `extData` | 支付返回 |
| `WeChatLaunchMiniProgramResponse` | `extMsg` | 小程序返回 App |
| `WeChatSubscribeMsgResponse` | `templateId, scene, action, reserved, openId` | 订阅消息 |
| `WeChatOpenCustomerServiceChatResponse` | `extMsg` | 客服会话返回 |
| `WeChatOpenBusinessViewResponse` / `WeChatOpenBusinessWebviewResponse` | `extMsg` 等 | businessView |
| `WeChatOpenInvoiceResponse` | `cardItemList` | 发票 |
| `WeChatShowMessageFromWXRequest` | `country, lang` | **Android** 被微信拉起 |
| `WeChatLaunchFromWXRequest` | `extMsg, country, lang` | **iOS** 被微信拉起 |
| `WeChatAuthGotQRCodeResponse` / `WeChatQRCodeScannedResponse` / `WeChatAuthByQRCodeFinishedResponse` | `qrCode` / — / `authCode` | 二维码登录三阶段 |

errCode 通用约定：`0` 成功，`-1` 通用错误，`-2` 用户取消，`-4` 拒绝授权。
