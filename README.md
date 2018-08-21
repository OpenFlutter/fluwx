![logo](/arts/fluwx_logo.png)

适用于Flutter的微信SDK，方便快捷。


## 写在前面
 使用```Fluwx```之前，强烈建议先阅读[微信SDK官方文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1)，
 这有助于你使用```Fluwx```。```Fluwx```的api字段名称基本和官方的字段名称是一致的。
 ios部分还在持续开发中。
## 引入
在```pubspec.yaml```文件中添加如下代码：
```yaml
dependencies:
  fluwx: ^0.0.1
```
## 初始化
 ```dart
 Fluwx.registerApp(RegisterModel(appId: "your app id", doOnAndroid: true, doOnIOS: true));
 ```
 - appId：在微信平台申请的appId。
 - doOnAndroid:是否在android平台上执行此操作。
 - doOnIOS:是否在平台上执行此操作。</br>
 每一个字段都是非必须的，但是如果不传appId或```doOnAndroid: false```或者```doOnIOS: false```，在使用前请务必手动注册```WXApi```，以保证
 Fluwx正常工作。
 注册完成后，请在对应平台添加如下代码：
 Android上：
 ```Kotlin
 FluwxShareHandler.setWXApi(wxapi)
 ```
 iOS上：
 ```objective-c
isWeChatRegistered = YES;
 ```


    注意：尽管可以通过Fluwx完成微信注册，但一些操作依然需要在对应平台进行设置，如配置iOS的URLSchema等。
## 开始分享
以分享文本和网址为例：
```dart
  var fluwx = Fluwx();
  fluwx.share(WeChatShareImageModel(image: "imagePath",thumbnail: "thumbanailPath"));
  fluwx.share(
              WeChatShareWebPageModel(
              webPage: "https://github.com/JarvanMo/fluwx",
              title: "Fluwx",
              thumbnail: "http://d.hiphotos.baidu.com/image/h%3D300/sign=1057e22c6ed9f2d33f1122ef99ee8a53/3bf33a87e950352aadfff8c55f43fbf2b3118b65.jpg",
              )).then((result){
               },
               onError: (msg){
               });
```
```fluwx.share(shareModel)```返回值为```bool```。
```fluwx.share(WeChatShareModel)```目前仅支持系统内```WeChatShareModel```的子类，不支持自定义。
所有字段名字和官方文档基本是一致的。
## 图片处理
图片仅支持```png```和```jpg```。
目前所有需要图片的地方支持网络图片及assets图片。</br>
使用assets图片需要添加```assets://```。</br>
也可以在assets图片添加```?package=package_name```以读取指定包的图片。</br>
未来可能支持```file://```。</br>
如果不指定schema或者schema错误,将会被处理为网络图片，请谨慎。</br>
## 注意
所有涉及缩略的最好给Fluwx一个合格的图片（小于32k,小程序小于120k），否则Fluwx将会对图片进行处理，这样做的结果可能并不是你所预期的，如缩略图被裁剪。
