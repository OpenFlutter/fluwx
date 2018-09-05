### 微信调回
微信的回调也要根据平台的不同进行差异化处理(如果你不需要回调，请忽略)。

### Android
由于机制问题，`Android`端需要在`WXEntryActivity`或`WXPayEntryActivity`中添加如下代码：
```kotlin
   override fun onResp(resp: BaseResp) {
        FluwxResponseHandler.handleResponse(resp)
   }
```
你也可以直接继承`FluwxWXEntryActivity`。
`WXEntryActivity`和`WXPayEntryActivity`创建规则请参阅官方文档。具体可以参考[example wxapi](https://github.com/OpenFlutter/fluwx/tree/master/example/android/app/src/main/kotlin/net/sourceforge/simcpux/wxapi )
，也不要忘记在`AndroidManifest.mxl`中注册：
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
在你的`AppDelegate.m`中重写下面方法：
```objective-c
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler responseHandler]];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler responseHandler]];
}
```

### Flutter
```dart
    _fluwx.response.listen((response){
      //do something
    });
```
从微信回调的值为`WeChatResponse`，其实`type`字段为枚举：
```dart
enum WeChatResponseType {
    SHARE,
    AUTH,
    PAYMENT }
```
`result`为微信回传的值，其类型为`Map`，具体返回值请参阅微信官方文档，但均额外包含一个
`platform`字段，其值为`android`或者`iOS`，以便开发者作差异化处理。
