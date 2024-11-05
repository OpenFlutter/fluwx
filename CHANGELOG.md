# 5.2.5
* 测试自动发布脚本

# 5.2.4
* Fix #663

# 5.2.3
* Fix #661

# 5.2.2
* Fix #659，优化iOS脚本，使其更加友好

# 5.2.1
* Merge #658

# 5.2.0
* 为iOS分享小程序增加hdImageData选项
* 优化Android图片分享逻辑，优先把LocalImagePath以最大限度保证图片质量

# 5.1.0
* 试验性支持harmonyOS，目前受限于native sdk，只支持部分功能

# 5.0.3
* 优化localImagePath处理，减轻非Android开发者的上手难度：localImagePath如果是以content://开头，则默认你已经挂载了相关路径的权限，
否则请务必保证该路径是文件实际保存路径，即Android层可以直接读取到该文件，以方便fluwx将文件拷贝到指定可用目录。

# 5.0.2
* 删除subscribeResponse, unsubscribeResponse

# 5.0.1
* Fix #642

# 5.0.0
* 使用了多端统一API，详情请点击[这里](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Share_and_Favorites/Android.html)
* 分享时所有的缩略图请使用`thumbData`字段
* Fluwx不会再对任何图片进行压缩处理

# 4.6.0
* Android SDK => 6.8.30
* 分享新增基础字段:thumbData
* 分享新增基础字段:thumbDataHash

# 4.5.6
* Merge #639

# 4.5.5
* iOS 最小版本支持为12.0

# 4.5.4
* Merge #606

# 4.5.3
* Merge #605

# 4.5.2
* Android WechatSdk->6.8.28
* iOS WeChatSdk->2.0.4

# 4.5.1
* Merge #602: 增加iOS privacy manifest

# 4.5.0
* Fix #599
* 破坏性更新：从4.5.0起，当分享图片到微信时，如果不支持FileProvider方式分享，Fluwx不再尝试申请WRITE_EXTERNAL_STORAGE权限，这意味着你需要自己处理权限问题。

# 4.4.10
* Merge #596

# 4.4.9
* Merge #591
* 

# 4.4.8
* Fix #543

# 4.4.7
* Response里asRecord更名为toRecord.
* Response相关实体类的内容比较应该对比toRecord结果

# 4.4.6
* Response里asString更名为asRecord.

# 4.4.5
* Response相关实体类增加asString方法，以方便debug.

# 4.4.4
* Android重写onReattachedToActivityForConfigChanges

# 4.4.3
* Fix #584 缩略图不显示问题

# 4.4.2
* 修复iOS回调会与其他插件冲突的问题

# 4.4.1
* Fix #575

# 4.4.0
* universal_link 不再是必选项

# 4.3.2
* iOS新增ignore_security选项，详见#576

# 4.3.1
* Merge #574

# 4.3.0
* Android minSdkVersion升级至19
* 主要解决了 iOS 端的冷启动参数传递问题

# 4.2.7

* 修复在Flutter module中编译不过的问题

# 4.2.6

* Fix #549

# 4.2.5

* iOS支持解析包含Anchors & Alias的Yaml

# 4.2.4+1

* 优化Android代码生成逻辑

# 4.2.4

* 修复iOS extMsg的问题

# 4.2.3

* 修复iOS冷启动extMsg的问题

# 4.2.2+1

* 更新iOS冷启动处理

# 4.2.2

* 删除iOS在registerApi并且开启debug_logging时自动自检
* 为iOS增加自检方法selfCheck
* subscribeResponse, unsubscribeResponse已废弃。
* 新增addSubscriber, removeSubscriber
* addSubscriber会返回Cancelable对象，可以直接调用cancel()函数。

# 4.2.1

* 支持选用scene_delegate.

# 4.2.0

* 修复ios上微信唤醒app崩溃的问题
* Android端重构
* app_id不再必填

# 4.1.1+1

* Fix Android compile issue

# 4.1.1

* 重构Android app_id处理

# 4.1.0

* 修复冷启动问题
* iOS端代码清理

# 4.0.1+1

* 更新iOS引用方式

# 4.0.1

* Fix #531

# 4.0.0+2

* flutter: ">=3.3.0"

# 4.0.0+1

* Fix iOS compile issue

# 4.0.0

* 重构Flutter端，现在需要`Fluwx fluwx = Fluwx();`调用fluwx实例
* 支持取消回传值的监听
* 枚举例按照dart语言规范进行了重命名
* 一些包含`WeChat`的方法删除了`WeChat`
* 部分类改为sealed class
* No_pay现已合并入Fluwx
* 将一些设置移到pubspec.yaml，具体可以参看`example/pubspec.yaml`
* 删除了log相关操作，因为现在可以通过yaml配置
* 新增一些open功能

# 4.0.0-pre.3

* `Fluwx`接口优化。合并了一些函数以优化使用体验。
* 修复Logging在iOS端不好的问题。

# 4.0.0-pre.2

* No_pay现已合并入Fluwx
* 将一些设置移到pubspec.yaml，具体可以参看`example/pubspec.yaml`
* 删除了log相关操作，因为现在可以通过yaml配置
* 增加了open()方法并删除了openWeChatApp

# 4.0.0-pre.1

* 重构Flutter端，现在需要`Fluwx fluwx = Fluwx();`调用fluwx实例
* 支持取消回传值的监听
* 枚举例按照dart语言规范进行了重命名
* 一些包含`WeChat`的方法删除了`WeChat`
* 部分类改为sealed class
* 最低dart版本>=3.1.0-26.0.dev

# 3.13.1

* 分享到小程序的thumbnail为必填

# 3.13.0

* Android SDK升级到6.8.24
* Kotlin升级到1.7.10
* iOS切换到WechatOpenSDK-XCFramework

# 3.12.2

* Fix #509

# 3.12.1

* 升级AGP
* Fix #512

# 3.12.0

* 授权登录支持关闭自动授权
* 分享支持添加签名，防止篡改

# 3.11.0+1

* Fix #506

# 3.11.0

* Fix #504

# 3.10.0

* 更新微信SDK

# 3.9.2

* 修复分享图片会导致Android无反应问题

# 3.9.1

* Fix issue getting extData on iOS

# 3.9.0+2

* Merge #485

# 3.9.0+1

* Merge #482

# 3.9.0

* 支持微信卡包

# 3.8.5

* Fix #471

# 3.8.4+3

* Fix #478 #466 #470 #472

# 3.8.4+2

* Fix #471
* 更换pod源

# 3.8.4+1

* Fix #471

# 3.8.4

* 增加微信的日志开关

# 3.8.2+1

* 升级kotlin-coroutine

# 3.8.2

* 新加自动订阅续费功能

# 3.8.1+1

* Just update docs

# 3.8.1

* 在iOS中增加FluwxDelegate
* 尝试修复iOS冷启动获取extMsg问题

# 3.8.0+2

* Fix #461

# 3.8.0

* APP调起支付分-订单详情

# 3.7.0

* Fix #453

# 3.6.1+4

* Android P support

# 3.6.1+3

* Fix #431

# 3.6.1+2

* Fix #422

# 3.6.1+1

* Fix #414

# 3.6.1

* Fix #415

# 3.6.0

* APP拉起微信客服功能

## 3.5.1

* 自动释放extMsg

## 3.5.0

* update compileSdkVersion

## 3.4.3

* update Android SDK version

## 3.4.2

* Merge #370

## 3.4.1

* 修复热启动传值问题

## 3.4.0

* 修复从外部拉起App白屏问题
* 修复从外部拉起App无法传值问题

## 3.3.2

* Fix #357

## 3.3.1

* Fix #354

## 3.3.0

* Null-safety support
* Fix #350

## 2.6.2

* Fix #338 on Android

## 2.6.1

* Fix #338

## 2.6.0+2

* Remove trailing

## 2.6.0+1

* Nothing

## 2.6.0

* Android支持通过H5冷启动app传递<wx-open-launch-app>中的extinfo数据
* Android新加<meta-data>handleWeChatRequestByFluwx</meta-data>。

## 2.5.0+1

* Fix trailing , issue.

## 2.5.0

* App获取开放标签<wx-open-launch-app>中的extinfo数据

## 2.4.2

* Fix #317

## 2.4.1

* 修复Android 11无法分享图片的问题

## 2.4.0

* 支持compressThumbnail
* 升级OkHttp

## 2.3.0

* 适配Flutter 1.20
* 升级Android的Gradle以及更库的版本

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
