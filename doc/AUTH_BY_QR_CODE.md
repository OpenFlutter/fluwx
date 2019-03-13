## AUTH BY QR CODE

When WeChat not installed on devices, user can login with WeChat-QRCode.

### Flutter

Request QRCode by the following codes:

```dart
fluwx.authByQRCode(
                  appId: "wxd930ea5d5a258f4f",
                  scope: "noncestr",
                  nonceStr: "nonceStr",
                  timeStamp: "1417508194",
                  signature: "429eaaa13fd71efbc3fd344d0a9a9126835e7303");
            }
```
[What do the params mean?](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=215238808828h4XN&token=&lang=zh_CN)


You can receive the data from WeChat through these ways:

```dart
//listening your auth status
    fluwx.onAuthByQRCodeFinished.listen((data){
          setState(() {
            _status =
                "errorCode=>${data.errorCode}\nauthCode=>${data.authCode}";
          });
        });

    //show your qrcode after this
    fluwx.onAuthGotQRCode.listen((image) {
      setState(() {
        _image = image;
      });
    });

    //qrcode was scanned
    fluwx.onQRCodeScanned.listen((scanned) {
      setState(() {
        _status = "scanned";
      });
    });
    
```
    
### Android
WeChatSDK will crash due to `HttpClient` when running on Android P,see this [solution](https://cloud.tencent.com/developer/ask/146536) for help .
