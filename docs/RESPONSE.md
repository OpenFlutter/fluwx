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
从微信回调的值为`WeChatResponse`，其实`type`字段为：
```dart
enum ResponseType {
    SHARE,
    AUTH,
    PAYMENT }
```
`result`为微信回传的值，其类型为`Map`，具体返回值请参阅微信官方文档，但均额外包含一个
`platform`字段，其实为`android`或者`iOS`，以便作差异化处理。