### Response From WeChat
There's some work we have to do on the particular plaform(if you don't need this,just ignore).

### Android
For`Android`,create `WXEntryActivity`or`WXPayEntryActivity`,and override the following function：
```kotlin

     public override fun onCreate(savedInstanceState: Bundle?) {
          super.onCreate(savedInstanceState)

          WXAPiHandler.wxApi?.handleIntent(intent, this)
      }

      override fun onNewIntent(intent: Intent) {
          super.onNewIntent(intent)

          setIntent(intent)
          WXAPiHandler.wxApi?.handleIntent(intent, this)
      }


      override fun onResp(resp: BaseResp) {

          FluwxResponseHandler.handleResponse(resp)
          finish()
      }
```
You can also directly inherit `FluwxWXEntryActivity`,and then you can do nothing.
For the rule of creating `WXEntryActivity`and`WXPayEntryActivity`,please read[example wxapi](https://github.com/OpenFlutter/fluwx/tree/master/example/android/app/src/main/kotlin/net/sourceforge/simcpux/wxapi )
，never register your Activity in `AndroidManifest.mxl`:
```xml
     <activity
            android:name="your.package.name.registered.on.wechat.wxapi.WXEntryActivity"
            android:theme="@style/DisablePreviewTheme"
            android:exported="true"
            android:launchMode="singleTop"/>
     <activity
            android:name="your.package.name.registered.on.wechat.wxapi.WXPayEntryActivity"
            android:theme="@style/DisablePreviewTheme"
            android:exported="true"
            android:launchMode="singleTop"/>

```

### iOS
override the following function in`AppDelegate.m`:
```objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

```

> NOTE:Don't forget to add URL Schema in order to go back to  your app.

### Flutter
We can get the reponse from WeChat after sharing and etc:
```dart
       fluwx.responseFromShare.listen((response){
         //do something
       });
       fluwx.responseFromAuth.listen((response){
         //do something
       });
       fluwx.responseFromPayment.listen((response){
         //do something
       });
```
> NOTE:If the field starts with "android" or "iOS", it means that only android or iOS has the field.

The type of return value is `WeChatResponse`，and  `type` is an enum:
```dart
enum WeChatResponseType {
    SHARE,
    AUTH,
    PAYMENT }
```
`result` is the real response from WeChat，it's a `Map`, read the WeChat documents for more details.
Howver,there an addtional param  `platform`，the value of `platform` is `android`or`iOS`.
