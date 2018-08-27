### 微信调回
微信的回调也要根据平台的不同进行差异化处理。

### Android
除了支付以外的回调，你需要在你的`WXEntryActivity`中添加如下代码,支付回调需要在`WXPayEntryActivity`中添加：
```kotlin
   override fun onResp(resp: BaseResp) {
        FluwxResponseHandler.handleResponse(resp)
   }
```
你也可以直接继承```FluwxWXEntryActivity```。