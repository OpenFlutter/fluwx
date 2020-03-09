## WeChat Not Installed on iOS?
if you have installed WeChat on your iPhone but you still catch an exception called "wechat not installed",just add the following
code to your *info.plist*:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
<string>weixin</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

## Can't Launch WeChat on Android?
Check your signature please.


## Failed to notify project evalution listener
[Failed to notify project evalution listener](https://www.jianshu.com/p/f74fed94be96)


## Can't receive response  after upgrading to 1.0.0 on iOS

There's no need to override `AppDelegate` since `fluwx 1.0.0`. If you have did thad before, please remove
the following code in your `AppDelegate`:

```objective-c

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
```

If you have to override these two functions,make sure you have called the `super`:
```objective-c

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
  return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
  return [super application:application openURL:url options:options];
}
```

**！！！！请先看[文档](https://github.com/OpenFlutter/fluwx/blob/master/README_CN.md)，再看常见Q&A，再查看issue，自我排查错误，方便你我他。依然无法解决的问题可以加群提问， QQ Group：892398530。！！！！**

## 常见Q&A

#### Fluwx调起失败？
请检查APPID、包名、以及App签名是否一致。debug 和release的签名默认不一样，请注意。

#### Android Flutter编译失败
1、检查Kotlin版本，打开```build.gradle```文件，查看以下配置
```
buildscript {
	······
	ext.kotlin_version = '1.3.11'
	······
}
```
确保项目中使用的Kotlin版本符合要求；
2、检查Android目录下```build.gradle```文件中gradle插件版本：```classpath 'com.android.tools.build:gradle:3.2.1'```和```gradle-wrapper.properties```文件中的gradle版本是否匹配：```distributionUrl=https\://services.gradle.org/distributions/gradle-4.10.1-all.zip```，两者的匹配规则见Android官网：[Update Gradle](https://developer.android.com/studio/releases/gradle-plugin.html#updating-gradle)

#### WeChat Not Installed on iOS?
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
受此影响，当你的应用在iOS 9中需要使用微信SDK的相关能力（分享、收藏、支付、登录等）时，需要在“Info.plist”里增加如下代码：
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
<string>weixin</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

#### 如果没有安装微信，微信登录不了，导致iOS审核失败
fluwx提供了检查用户是否安装微信的方法：```isWeChatInstalled()```，iOS使用微信相关功能前，务必先检查微信是否安装。

#### Failed to notify project evalution listener
[Failed to notify project evalution listener](https://www.jianshu.com/p/f74fed94be96)

#### isWeChatInstalled返回false
请查看该 [issue](https://github.com/OpenFlutter/fluwx/issues/34)  ，检查```AppDelegate```中配置是否正确。

#### Kotlin报错：XXX is only available since Kotlin 1.3 and cannot be used in Kotlin 1.2
1、请检查IDE安装的Kotlin插件版本是否符合fluwx要求：AS打开设置-->Plugin-->Koltin查看插件版本；
2、请检查项目中使用的Kotlin版本：打开```build.gradle```文件，查看以下配置
```
buildscript {
	······
	ext.kotlin_version = '1.3.11'
	······
}
```

#### listen监听多次调用
请查看该 [issue](https://github.com/OpenFlutter/fluwx/issues/36)  。这个问题是由于listen被多次注册导致的，使用者自己代码的问题，非fluwx导致的，请在合适的时机将listen cancel掉：
```
StreamSubscription<WeChatAuthResponse> _wxlogin;
_wxlogin = fluwx.responseFromAuth.listen((val) {})
@override
  void dispose() {
	_wxlogin.cancel();
}
```

#### 分享完成或者取消分享后App崩溃
如果你手动注册了```WXEntryActivity```and```WXPayEntryActivity```，请检查```Manifest```中包名是否写对了。

#### IOS编译错误：No such module 'fluwx'
如果项目本身是在Android环境配置的，移到iOS的环境的时候，会出现该问题，请按照正常步骤配置。

#### 支付成功后，按物理按键或手机自动返回商户APP，监听不到返回数据

有人反应会出现```fluwx.responseFromPayment.listen```监听无效，无法获取支付结果，建议可以直接向服务器查询是否成功。

#### iOS报错：Specs satisfying the `fluwx (from `.symlinks/plugins/fluwx/ios`)` dependency were found, but they required a higher minimum deployment target.
请在在pod file里将iOS项目deployment target改到9.0。

#### ResponseType与Dio插件中的命名冲突
使用as的方式导包即可：```import 'package:fluwx/fluwx.dart' as fluwx;```

