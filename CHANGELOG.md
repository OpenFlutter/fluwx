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
