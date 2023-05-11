## Payment

Calling payment is easy but to make it work isn't not so easy:

```dart
fluwx.pay(
      which: Payment(
      appId: result['appid'].toString(),
      partnerId: result['partnerid'].toString(),
      prepayId: result['prepayid'].toString(),
      packageValue: result['package'].toString(),
      nonceStr: result['noncestr'].toString(),
      timestamp: result['timestamp'],
      sign: result['sign'].toString(),
));
```

Take a look at [payment document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=11_1#) for help.
