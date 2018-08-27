# 微信支付
## Android

### 拉起支付
```dart
Fluwx fluwx = new Fluwx();
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
### 返回值处理
注：此返回值是此方法调用的直接返回值，并非支付之后的回调，回调请查看[相关文档](docs/RESPONSE.md)

 ```fluwx.pay(model)```返回的是一个```Map```：
```dart
    {
      "platform":"Android",//或者iOS
       result:true //或者false，取决于WXApi.sendRequest()的结果
     }
```
  