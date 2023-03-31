# 3.12.3
* Fix 520

# 3.12.2
* Fix #509

# 3.12.1
* 升级AGP
* Fix #512

# 3.12.0
* 授权登录支持关闭自动授权
* 分享支持添加签名，防止篡改

# 3.11.0
* Fix #504

# 3.10.0
* 更新微信SDK

# 3.9.1
* 修复分享图片会导致Android无反应问题

# 3.9.0+1
* Merge #485

# 3.9.0
* 支持微信卡包

# 3.8.5
* Fix #471

# 3.8.4+3
* Fix #478 #466 #470 #472

# 3.8.4+2
* Fix #472

# 3.8.4+1
* Fix #471

# 3.8.4
* 增加微信的日志开关

# 3.8.3
* Merge #457

# 3.8.2+1
* 升级kotlin-coroutine

# 3.8.2
* 新加自动订阅续费功能

# 3.8.1+1
* Just update docs

# 3.8.1
* 在iOS中增加FluwxDelegate
* 尝试修复iOS冷启动获取extMsg问题

# 3.8.0+3
* Fix #462

# 3.8.0+2
* Fix #461

# 3.8.0+1
* Fix #460

# 3.8.0
* APP调起支付分-订单详情

# 3.7.0
* Mirror of #455

# 3.6.1+6
* Fix #454

# 3.6.1+5
* Support Android P

# 3.6.1+4
* Fix #431

# 3.6.1+3
* Fix #422

# 3.6.1+2
* APP拉起微信客服功能

# 3.6.1+1
* Fix #419
* Fix #414

# 3.6.1
* Fix #416

# 3.6.0
* APP拉起微信客服功能

# 3.5.1
* 自动释放extMsg

# 3.5.0
* update compileSdkVersion

# 3.4.4
* update android sdk version

# 3.4.3
* Merge #370

# 3.4.2
* 修复Android编译问题

# 3.4.1
* 修复从外部拉起App白屏问题
* 修复从外部拉起App无法传值问题


# 3.4.0
* 修复从外部拉起App白屏问题
* 修复从外部拉起App无法传值问题

# 3.2.2
* Fix #357

# 3.2.1
* Fix #354

# 3.2.0
* Null-safety
* Fix #350

## 3.1.2-nullsafety.1
* Fix #338

## 3.1.1-nullsafety.1
* Fix #338

## 3.1.0-nullsafety.3
* Nothing

## 3.1.0-nullsafety.2
* Nothing

## 3.1.0-nullsafety.1
* Android支持通过H5冷启动app传递<wx-open-launch-app>中的extinfo数据
* Android新加<meta-data>handleWeChatRequestByFluwx</meta-data>。

## 3.0.0-nullsafety.2
* Fix trailing , issue

## 3.0.0-nullsafety.1
* Support nullsafety

## 2.4.0
* App获取开放标签<wx-open-launch-app>中的extinfo数据

## 2.3.2
* Fix #317

## 2.3.1
* 修复Android 11分享图片问题

## 2.3.0
* 支持compressThumbnail
* 升级OkHttp

## 2.2.0
*兼容Flutter 1.20
*一些依赖升级

## 2.1.1
* Specifying supported platforms
* Fix: Android分享小程序时，缩略图压缩过重的问题
* 更改分享文件的实现形式

# 2.1.0
* WeChatSDK updates

# 2.0.4
* Fix #223

## 2.0.3+1
* Merge #218

## 2.0.3
* Fix #212

## 2.0.1+2
* Fix: Android分享大图时存储权限问题

## 2.0.1+1
* Fix: Android请求权限崩溃的问题

## 2.0.1
* Fix: Android请求权限崩溃的问题

## 2.0.0
* 按照pub建议改进

* 代码重构，现在代码结构更清晰
* 所有图片由WeChatImage构建
* 现在iOS对分享微信小程序的高清图也会压缩
* 微信回调监听形式变更
* Android增加新的Action以防微信打开小程序出错不会返回原app的问题
* iOS改用Pod引用微信SDK
* iOS隐藏一些header
* kotlin 1.3.70

## 1.0.0

* Initial Release.