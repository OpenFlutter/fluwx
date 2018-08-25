## 发送Auth验证
```Fluwx```目前只支持获取```code```，若要获取```access_token```请在服务器端完成。
```dart
   fluwx.sendAuth(WeChatSendAuthModel(
      scope: "snsapi_userinfo",
          state:"wechat_sdk_demo_test",
    ));
```
