## 发送Auth验证
`Fluwx`目前只支持获取`code`，若要获取`access_token`请在服务器端完成。
```dart
   import 'package:fluwx/fluwx.dart' as fluwx;
   fluwx.sendAuth(WeChatSendAuthModel(
      scope: "snsapi_userinfo",
          state:"wechat_sdk_demo_test",
    ));
```
### 返回值处理
 `fluwx.share(model)`返回的是一个`Map`：
```dart
    {
       "platform":"Android",//或者iOS
       result:true //或者false，取决于WXApi.sendRequest()的结果
     }
```