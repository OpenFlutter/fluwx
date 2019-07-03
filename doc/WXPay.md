

### Pay
 
```dart
import 'package:fluwx/fluwx.dart' as fluwx;
fluwx.pay(WeChatPayModel(
                  appId: 'wxd930ea5d5a258f4f', 
                  partnerId: '1900000109',
                  prepayId: '1101000000140415649af9fc314aa427',
                  packageValue: 'Sign=WXPay',
                  nonceStr: '1101000000140429eb40476f8896f4c9',
                  timeStamp: '1398746574',
                  sign: '7FFECB600D7157C5AA49810D2D8F28BC2811827B',
                  signType: '选填',
                  extData: '选填'
                ));
```
### Return 
The return value of `fluwx.share(model)` is a `Map`：

 `fluwx.pay(model)`返回的是一个`Map`：
```dart
    {
      "platform":"Android",//or iOS
       result:true //or false，depends on WXApi.sendRequest()
     }
```
For the response from WeChat,read [RESPONSE](./RESPONSE.md) please.
  
