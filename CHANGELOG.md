## 2.2.0
* Merged #249

## 2.1.0
* Specifying supported platforms
* Fix: Android分享小程序时，缩略图压缩过重的问题
* 更改分享文件的实现形式

## 2.0.9
* Android SDK 升级到6.6.4
* iOS SDK升级到1.8.7.1
* Kotlin->1.3.72

## 2.0.8+3
* Merge #218

## 2.0.8+2
* Merge #218

## 2.0.8+1
* 修复ios编译错误

## 2.0.8
* Fix #212

## 2.0.7
* Fix #207

## 2.0.6+2
* Fix: Android分享大图时存储权限问题

## 2.0.6
* Fix: Android请求权限崩溃的问题

## 2.0.5+1
* 升级

## 2.0.5
* Fix:Android分享file文件时，会crash

## 2.0.4
* Fix:hdImage为空时，ios会crash

## 2.0.3
* 添加混淆文件

## 2.0.2
* Fix #199

## 2.0.1
* 修复Android没有回调的问题

## 2.0.0+1
* 按照pub建议改进

## 2.0.0
* 代码重构，现在代码结构更清晰
* 所有图片由WeChatImage构建
* 现在iOS对分享微信小程序的高清图也会压缩
* 微信回调监听形式变更
* Android增加新的Action以防微信打开小程序出错不会返回原app的问题
* iOS改用Pod引用微信SDK
* iOS隐藏一些header
* kotlin 1.3.70

## 1.2.1+2
* iOS的StringUtil重命名了

## 1.2.1+1
* Fix #178

## 1.2.1
* Fix #175

## 1.2.0
* 分享文件
* compileSdkVersion 29

## 1.1.4

* 注册微信时会对universal link进行简单校验

## 1.1.3

* Fix #146

## 1.1.2

* Fix #122

## 1.1.1+1

* Android CompileSDKVersion 提升到28

### 1.1.1

* registerWxApi

## 1.1.0

* iOS SDK升级至1.8.6.1，本版本开始支持universal link。
* Android SDK更换至without-mat:5.4.3
* Android配置升级
* 移除MTA选项


## 1.0.6
* Fix #110

## 1.0.5
* 增加分享内存图片

## 1.0.4
* 解决Android上打开小程序返回白屏问题（非官方解决方案）

## 1.0.3
* 修复一些小问题

## 1.0.2
* 修复无法Android上分享大图的问题

## 1.0.1
* 修复一些小问题


## 1.0.0
* ios不必再重写AppDelegate

## 0.6.3

* 免密支付
* 支持打开微信App了
* 升级了Android

## 0.6.2

* 对android进行了升级

## 0.6.1
* 支持二维码登录

## 0.6.0
* kotlin升级至1.3.21。
* ios SDK升级至1.8.4。
* android SDK升级至5.3.6。

## 0.5.7
* 修复问题43。

## 0.5.6


## 0.5.5
* 修复ios分享小程序标题不正确的问题。

## 0.5.4
* 增加一次性订阅消息功能。

## 0.5.3
* 修复唤起小程序返回值类型不一致的问题。


## 0.5.2
* 修复ios上sendAuth无返回的问题。
* kotlin升级至1.3.10
* android WeChatSDK升级到5.1.6

## 0.5.1
* Kotlin升级到了1.3.0
* 代码格化

## 0.5.0
* 增加了对拉起小程序的支持
* 删除了一些不必要的类
* 发送Auth验证Api调整


## 0.4.1
* 修复iOS与其他库共存时，会有重复的错误

## 0.4.0
* 移除WeChatPayModel
* 移除ios最小支持。
* 优化*Android*微信回调。
* *build.gradle*升级到了*3.2.1*。

## 0.3.2
* *build.gradle*升级到了*3.2.0*
* *kotlin*升级到了*1.2.71*

## 0.3.1
* 修复了由于Flutter-dev-0.9.7-pre在android中添加了*@Nullable*注解而引起的编译问题

## 0.3.0
* 回调方式发生变化，由Map变更为实体类。
* iOS的WeChatSDK更换为内部依赖，并升级到了1.8.3。
* 修复iOS支付返回结果缺少*returnKey*的问题。
* API现在更加友善了。
* 对swift支持更友好了。

## 0.2.1
* 修复在Android处理网络图片后缀不对的问题。

## 0.2.0
* iOS支持Swift了。

## 0.1.9
* 修复了不传*thumbnail*在Android上会崩溃的bug。

## 0.1.8
* `WeChatPayModel`里的字段不再是`dynamic`。
* 修复了iOS对支付功能中timestamp处理不正确的问题。

## 0.1.7
* 删除`Fluwx.registerApp(RegisterModel)`，现在使用`Fluwx.register()`。

## 0.1.6
* 修复transitive dependencies。

## 0.1.5
* 增加了本地图片的支持

## 0.1.4
* 修复了iOS分享去处错误的问题

## 0.1.3
* `ResponseType` 更名为`WeChatResponseType`
## 0.1.2
* 修复iOS中FluwxShareHandler.h的导入问题

## 0.1.1
* 修复iOS分享去处错误的bug

## 0.1.0
* 增加了MTA选项
* Android部分的微信SDK提供方式由implementation更换为api

## 0.0.8
* 修复了iOS无法分享小程序的bug
* 修复了iOS分享音乐崩溃的问题
* 修复了iOS发送Auth偶尔会崩溃的问题

## 0.0.7
* 修复了iOS回调崩溃的bug

## 0.0.6
* 修复iOS拉起支付崩溃的问题

## 0.0.5
* 格式化代码

## 0.0.4
* 支付
* demo

## 0.0.3
* 发送Auth认证。

## 0.0.2

* 文本分享。
* 网站分享。
* 图片分享。
* 音乐分享。
* 视频分享。
* 小程序分享。

## 0.0.1

* Android部分的分享已完成.
