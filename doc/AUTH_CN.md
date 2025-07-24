## 登录

`sendWeChatAuth`的目的是为了获取code，拿到了code才能进行微信登录，可以通过[官方文档](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html#:~:text=%E5%BD%93%E5%89%8D%E5%9B%BD%E5%AE%B6%E4%BF%A1%E6%81%AF-,%E7%AC%AC%E4%BA%8C%E6%AD%A5,-%EF%BC%9A%E9%80%9A%E8%BF%87%20code%20%E8%8E%B7%E5%8F%96)查看具体流程。

```dart
Fluwx fluwx = Fluwx();
fluwx.authBy(which: NormalAuth(scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test'));
```
请查阅[example](https://github.com/OpenFlutter/fluwx/blob/9258ac96df2ca5316c06dc3be078a1b123b47bdd/example/lib/pages/send_auth_page.dart#L18-L19)获取更多信息。

> 为什么不支持获取用户信息？ 我认为获取用户信息应该后端来做，即使没有后端，你也可以在dart层自己实现.

