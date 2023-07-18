## 支付

调用支付方法很简单，但想成功并不简单：

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

  

## 安卓支付

* 登录[微信开放平台](https://open.weixin.qq.com/cgi-bin/index?t=home/index&lang=zh_CN&token=f3443bb5b660c02dbbc86fb324adce3239e5ab22),填写相关信息

![image-20210523132928727](https://gitee.com/inkkk0516/typora/raw/master/image-20210523132928727.png)

* 根据`应用包名`生成`应用签名` [点击这里下载应用签名工具](https://developers.weixin.qq.com/doc/oplatform/Downloads/Android_Resource.html), 安装好签名工具后，输入应用包名就可以生成应用签名了

![image-20210523133551034](https://gitee.com/inkkk0516/typora/raw/master/image-20210523133551034.png)

  

更多信息还查看[支付文档](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=11_1#)吧.
