### 微信调回
微信的回调也要根据平台的不同进行差异化处理。

### Android
需要在`WXEntryActivity`或`WXPayEntryActivity`中添加如下代码：
```kotlin
   override fun onResp(resp: BaseResp) {
        FluwxResponseHandler.handleResponse(resp)
   }
```
你也可以直接继承`FluwxWXEntryActivity`。

### iOS
在你的`AppDelegate`中重写下面方法：
```objective-c
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return  [WXApi handleOpenURL:url delegate:[FluwxResponseHandler responseHandler]];
}

```

### Flutter
