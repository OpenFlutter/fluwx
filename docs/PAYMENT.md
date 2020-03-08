## Payment

Calling payment is easy but to make it work isn't not so easy:

```dart
payWithWeChat(
                appId: result['appid'],
                partnerId: result['partnerid'],
                prepayId: result['prepayid'],
                packageValue: result['package'],
                nonceStr: result['noncestr'],
                timeStamp: result['timestamp'],
                sign: result['sign'],
              );
```

Take a look at [payment document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=11_1#) for help.
