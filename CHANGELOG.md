## 2.3.0
支持compressThumbnail
升级OkHttp

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