## 登录

`sendWeChatAuth`的目的是为了获取code，拿到了code才能进行微信登录，可以通过[官方文档](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html)查看具体流程。

```dart
 sendWeChatAuth(scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
```

> 为什么不支持获取用户信息？ 我认为获取用户信息应该后端来做，即使没有后端，你也可以在dart层自己实现.

