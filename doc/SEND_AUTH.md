## Send Auth
We'll get a `code` by sending auth:
```dart
   import 'package:fluwx/fluwx.dart' as fluwx;
   fluwx.sendAuth(WeChatSendAuthModel(
      scope: "snsapi_userinfo",
          state:"wechat_sdk_demo_test",
    ));
```
`Fluwx` doesn't support getting `access_toke`.
### Return
 The return value of `fluwx.share(model)` is a `Map`：
```dart
    {
       "platform":"Android",//or iOS
       result:true //or false，depending on the result of WXApi.sendRequest()
     }
```