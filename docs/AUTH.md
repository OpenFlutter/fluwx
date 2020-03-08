## AUTH

The purpose of `sendWeChatAuth` is to get auth code and then get information for WeChat login.
Getting `access_token` is not supported in `fluwx`. For `access_token`, please visit [official documents](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html).

```dart
 sendWeChatAuth(scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
```

> WHY? I think we shall fetch access_token or user info at backend.

