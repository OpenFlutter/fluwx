**！！！！请先看[文档](https://github.com/OpenFlutter/fluwx/blob/master/README_CN.md)，再看常见Q&A，再查看issue，自我排查错误，方便你我他。依然无法解决的问题可以加群提问， QQ Group：892398530。！！！！**

## 常见Q&A
[fluwx安卓端调起失败？](#fluwx安卓端调起失败)  
[安卓端编译失败](#安卓端编译失败)  
[无法调起支付](#无法调起支付)  
[安卓端编译报错AndroidX相关](#安卓端编译报错androidx相关)  
[WeChat Not Installed on iOS?](#wechat-not-installed-on-ios)  
[iOS上升级到1.0.0 后无法接收回调](#ios上升级到100-后无法接收回调)  
[没有安装微信，微信登录不了，导致iOS审核失败](#没有安装微信微信登录不了导致ios审核失败)
[Failed to notify project evalution listener](#failed-to-notify-project-evalution-listener)  
[isWeChatInstalled返回false](#iswechatinstalled返回false)
[Kotlin报错：XXX is only available since Kotlin x.xx and cannot be used in Kotlin x.xx](#kotlin报错xxx-is-only-available-since-kotlin-xxx-and-cannot-be-used-in-kotlin-xxx)  
[listen监听多次调用](#listen监听多次调用)  
[分享完成或者取消分享后App崩溃](#分享完成或者取消分享后app崩溃)  
[IOS编译错误：No such module 'fluwx'](#ios编译错误no-such-module-fluwx)  
[支付成功后，按物理按键或手机自动返回商户APP，监听不到返回数据](#支付成功后按物理按键或手机自动返回商户app监听不到返回数据)
[iOS报错：Specs satisfying the fluwx (from .symlinks/plugins/fluwx/ios) dependency were found, but they required a higher minimum deployment target.](#ios报错specs-satisfying-the-fluwx-from-symlinkspluginsfluwxios-dependency-were-found-but-they-required-a-higher-minimum-deployment-target)  
[ResponseType与Dio插件中的命名冲突](#responsetype与dio插件中的命名冲突)
[ShareSDK(分享插件)和Fluwx(微信支付插件)存在冲突](#sharesdk分享插件和fluwx微信支付插件存在冲突)
[图片加载失败？](#图片加载失败)
[iOS registerWxApi 返回-1](#iOS registerWxApi 返回-1)  
[分享后，打开微信出现未审核应用](#分享后打开微信出现未审核应用)
[分享怎样知道是成功分享了还是取消了没有分享](#分享怎样知道是成功分享了还是取消了没有分享)
[运行时报错kotlinx相关](#运行时报错kotlinx相关)
[android手机在拉起微信前会弹出选择微信分身页面](#android手机在拉起微信前会弹出选择微信分身页面)
[android代码混淆](#android代码混淆)

### fluwx安卓端调起失败？
请检查APPID、包名、以及App签名是否一致。debug 和release的签名默认不一样，请注意。注意签名规则：https://github.com/OpenFlutter/fluwx/issues/89#issuecomment-515948671 ，keystore工具生成的MD5需要去除横杆并且全部转换为小写，然后配置到build.gradle。

### 安卓端编译失败
1、检查Kotlin版本，打开```build.gradle```文件，查看以下配置
```
buildscript {
	······
	ext.kotlin_version = '1.3.31'
	······
}
```
确保项目中使用的Kotlin版本符合要求（具体版本号以demo为准）；
2、检查Android目录下```build.gradle```文件中gradle插件版本：```classpath 'com.android.tools.build:gradle:3.2.1'```和```gradle-wrapper.properties```文件中的gradle版本是否匹配：```distributionUrl=https\://services.gradle.org/distributions/gradle-4.10.1-all.zip```，两者的匹配规则见Android官网：[Update Gradle](https://developer.android.com/studio/releases/gradle-plugin.html#updating-gradle)

### 无法调起支付
1、先认真阅读[微信支付业务流程](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_3)，确保操作没问题；  
2、打印微信返回的错误码，对照下面的表格排查：

| 名称   | 描述    | 解决方案                |
| ----- | ------- | ------------------- |
| 0     | 成功    | 展示成功页面            |
| -1    | 错误    | 可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。|
| -2    | 用户取消 | 无需处理。发生场景：用户不支付了，点击取消，返回APP。                   |
  
3、大部分情况下errorCode为-1，请按照以下两部来进一步检查：（1）检查签名、appID、商户ID等配置是否正确（前两项可以通过检查是否可以成功调用分享来决定）；（2）如果确保配置正确，那就只可能是后端生成的订单信息有误，请让后端排查错误，大概率是appID写错了。  
4、暂时发现某些华为品牌手机会出现支付调用失败的情况，这是厂商问题，与Fluwx无关。  

### 安卓端编译报错AndroidX相关
如果报错含有“AndroidX”、“support”等相关字眼，提示包重复，请将自己的项目升级，支持AndroidX，具体参考：[Migrating to AndroidX](https://www.kikt.top/posts/flutter/migrate-android-x/)

### WeChat Not Installed on iOS?
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
受此影响，当你的应用在iOS 9中需要使用微信SDK的相关能力（分享、收藏、支付、登录等）时，需要在“Info.plist”里增加如下代码（不会配请参考[example](https://github.com/OpenFlutter/fluwx/blob/master/example/ios/Runner/Info.plist)）：
```
xml
<key>LSApplicationQueriesSchemes</key>
<array>
<string>weixin</string>
<string>weixinULAPI</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

### iOS上升级到1.0.0 后无法接收回调

从`fluwx 1.0.0`开始开发者不必重写`AppDelegate`了。如果你以前重写了这个方法,请在 `AppDelegate`中删除相应的代码:

```objective-c

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
```

如果一定要重写这2个方法,请确保你调用了 `super`:
```objective-c

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
  return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
  return [super application:application openURL:url options:options];
}
```

### 如果没有安装微信，微信登录不了，导致iOS审核失败

fluwx提供了检查用户是否安装微信的方法：```isWeChatInstalled()```，iOS使用微信相关功能前，务必先检查微信是否安装，没有安装微信的话请务必隐藏微信相关功能。

### Failed to notify project evalution listener
[Failed to notify project evalution listener](https://www.jianshu.com/p/f74fed94be96)

### isWeChatInstalled返回false
请查看该 [issue](https://github.com/OpenFlutter/fluwx/issues/34)  ，检查```urlScheme```是否配置正确，是否配置了白名单；如果重写了```AppDelegate```，请检查配置是否正确。

### Kotlin报错：XXX is only available since Kotlin x.xx and cannot be used in Kotlin x.xx
1、请检查IDE安装的Kotlin插件版本是否符合fluwx要求：AS打开设置-->Plugin-->Koltin查看插件版本；  
2、请检查项目中使用的Kotlin版本：打开```build.gradle```文件，查看以下配置（具体版本号以demo为准）
```
buildscript {
	······
	ext.kotlin_version = '1.3.11'
	······
}
```

### listen监听多次调用
请查看该 [issue](https://github.com/OpenFlutter/fluwx/issues/36)  。这个问题是由于listen被多次注册导致的，使用者自己代码的问题，非fluwx导致的，请在合适的时机将listen cancel掉：
```
StreamSubscription<WeChatAuthResponse> _wxlogin;
_wxlogin = fluwx.responseFromAuth.listen((val) {})
@override
  void dispose() {
	_wxlogin.cancel();
}
```

### 分享完成或者取消分享后App崩溃
如果你手动注册了```WXEntryActivity```and```WXPayEntryActivity```，请检查```Manifest```中包名是否写对了。

### IOS编译错误：No such module 'fluwx'
如果项目本身是在Android环境配置的，移到iOS的环境的时候，会出现该问题，请按照正常步骤配置。

### 支付成功后，按物理按键或手机自动返回商户APP，监听不到返回数据
有人反应会出现```fluwx.responseFromPayment.listen```监听无效，无法获取支付结果，建议可以直接向服务器查询是否成功。

### iOS报错：Specs satisfying the `fluwx (from `.symlinks/plugins/fluwx/ios`)` dependency were found, but they required a higher minimum deployment target.
请在在pod file里将iOS项目deployment target改到9.0。

### ResponseType与Dio插件中的命名冲突
使用as的方式导包即可：```import 'package:fluwx/fluwx.dart' as fluwx;```

### ShareSDK(分享插件)和Fluwx(微信支付插件)存在冲突
1、将S hareSDK 的```/ios/sharesdk.podspec```里的 ```s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChat' ```改为  ``` s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'```
2、删除 fluwx 的```/ios/Lib```里的```libWeChatSDK.a```，在```/ios/fluwx.podspec```里添加```s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'```

### 图片加载失败？
1、检查是否是图片大小过大，过大请压缩；
2、检查图片路径是否是符合要求的scheme形式，具体规则请看：[都支持什么图片](https://github.com/yumi0629/fluwx/blob/master/doc/SHARE_CN.md#%E9%83%BD%E6%94%AF%E6%8C%81%E4%BB%80%E4%B9%88%E5%9B%BE%E7%89%87)
3、如果是使用的Asset图片，请不要将图片放在```assets```文件夹中，可能会读取不到。

### iOS registerWxApi 返回 -1
检查初始化时APP ID以及universal link是不是写对了。

### 分享后，打开微信出现未审核应用
微信自己做的限制，非fluwx问题，建议找微信客服

### 分享怎样知道是成功分享了还是取消了没有分享
无法获取。请阅读微信分享文档：[微信App分享功能调整](https://open.weixin.qq.com/cgi-bin/announce?spm=a311a.9588098.0.0&action=getannouncement&key=11534138374cE6li&version=)。现在开始微信SDK不再返回用户是否分享完成事件，取消/成功统一全部返回成功。

### 运行时报错kotlinx相关
检查是否开启混淆；可以参考这个[issue](https://github.com/OpenFlutter/fluwx/issues/94)，请确保宿主app Kotlin版本不支持kotlinx

### android手机在拉起微信前会弹出选择微信分身页面
微信分身是属于系统范畴的问题，与Fluwx无关。

### android代码混淆
请手动给lib里的package添加混淆规则，具体参考微信文档。
