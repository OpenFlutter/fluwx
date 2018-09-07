### Response From WeChat
There's some work we have to do on the particular plaform(if you don't need this,just ignore).

### Android
For`Android`,create `WXEntryActivity`or`WXPayEntryActivity`,and override the following function：
```kotlin
   override fun onResp(resp: BaseResp) {
        FluwxResponseHandler.handleResponse(resp)
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
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler responseHandler]];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler responseHandler]];
}
```

> NOTE:Don't forget to add URL Schema in order to go back to  your app.

### Flutter
We can get the reponse from WeChat after sharing and etc:
```dart
    _fluwx.response.listen((response){
      //do something
    });
```
The type of return value is `WeChatResponse`，and  `type` is an enum:
```dart
enum WeChatResponseType {
    SHARE,
    AUTH,
    PAYMENT }
```
`result` is the real response from WeChat，it's a `Map`, read the WeChat documents for more details.
Howver,there an addtional param  `platform`，the value of `platform` is `android`or`iOS`.
