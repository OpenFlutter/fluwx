## 二维码登录

如果用户没有安装微信，我们可以通过扫描二维码登录.

### Flutter

请求一个二维码:

```dart
fluwx.authByQRCode(
                  appId: "wxd930ea5d5a258f4f",
                  scope: "noncestr",
                  nonceStr: "nonceStr",
                  timeStamp: "1417508194",
                  signature: "429eaaa13fd71efbc3fd344d0a9a9126835e7303");
            }
```
[这些参数都是什么意思?](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=215238808828h4XN&token=&lang=zh_CN)

通过以下方式监听扫描过程:

```dart
//当扫码完成
    fluwx.onAuthByQRCodeFinished.listen((data){
          setState(() {
            _status =
                "errorCode=>${data.errorCode}\nauthCode=>${data.authCode}";
          });
        });

    //这个时候可以显示你的二维码了
    fluwx.onAuthGotQRCode.listen((image) {
      setState(() {
        _image = image;
      });
    });

    //二维码被扫描了
    fluwx.onQRCodeScanned.listen((scanned) {
      setState(() {
        _status = "scanned";
      });
    });
    
```
    
### Android
在Android P上，微信SDK会闪退， 查看[该文章](https://cloud.tencent.com/developer/ask/146536)以寻求帮助.
