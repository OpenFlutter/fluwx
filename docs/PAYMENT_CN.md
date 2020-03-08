## 支付

调用支付方法很简单，但想成功并不简单：

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

更多信息还查看[支付文档](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=11_1#)吧.
