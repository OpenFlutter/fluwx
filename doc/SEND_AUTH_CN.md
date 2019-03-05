## 发送Auth验证
`Fluwx`目前只支持获取`code`，若要获取`access_token`请在服务器端完成。
```dart
   import 'package:fluwx/fluwx.dart' as fluwx;
   fluwx.sendAuth(
         scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")；
```
