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

## iOS 支付

* 配置`URL Schemes` ，内容为应用的`AppID`, 可以登录微信开放平台查看。编辑`ios/Runner/Info.plist`

  ```xml
  <key>CFBundleURLSchemes</key>
  <array>
    <string>wx84cxxxxxx</string>
  </array>
  ```

* 配置`LSApplicationQueriesSchemes`

  ![image-20210523140138835](https://gitee.com/inkkk0516/typora/raw/master/image-20210523140138835.png)

* 使用

  ```dart
  await fluwx.registerWxApi(
            appId: "wx84cfexxxxxx",
            universalLink: "https://www.xxxx.cn/app/");
  
  fluwx.payWithWeChat(
    appId: result['appid'],
    partnerId: result['partnerid'],
    prepayId: result['prepayid'],
    packageValue: result['package'],
    nonceStr: result['noncestr'],
    timeStamp: result['timestamp'],
    sign: result['sign'],
  )
  ```

  

## 安卓支付

* 登录[微信开放平台](https://open.weixin.qq.com/cgi-bin/index?t=home/index&lang=zh_CN&token=f3443bb5b660c02dbbc86fb324adce3239e5ab22),填写相关信息

![image-20210523132928727](https://gitee.com/inkkk0516/typora/raw/master/image-20210523132928727.png)

* 根据`应用包名`生成`应用签名` [点击这里下载应用签名工具](https://developers.weixin.qq.com/doc/oplatform/Downloads/Android_Resource.html), 安装好签名工具后，输入应用包名就可以生成应用签名了

![image-20210523133551034](https://gitee.com/inkkk0516/typora/raw/master/image-20210523133551034.png)


* 使用

  ```dart
  // 注册
  await fluwx.registerWxApi(
            appId: "wx84cxxxxxx",
            universalLink: "https://www.xxxx.cn/app/");
  
  // 监听支付结果
  fluwx.weChatResponseEventHandler.listen((event) async {
    print(event.errCode);
  	// 支付成功  
    if (event.errCode == 0) {
    }
    // 关闭弹窗
  });
  ```

  

更多信息还查看[支付文档](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=11_1#)吧.
