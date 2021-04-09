## 从H5启动app
Fluwx 支持从`<wx-open-launch-app>`启动你的app, 并且支持传递`extInfo`给你的app.
对于Android来说,你要在`AndroidManifest.xml`中给你的`Activity`加上一个标签:
```
<intent-filter>
    <action android:name="${applicationId}.FlutterActivity" />
    <category android:name="android.intent.category.DEFAULT" />
</intent-filter>
```

与此同时，你还需要在需要在application中加上`<meta-data>`,把你的appId放进去:

```xml
        <meta-data
            android:name="weChatAppId"
            android:value="12345678" />

```

如果你想把`extInfo`传给Flutter, 你要在`MainActivity`加上如下代码:
```kotlin
  override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //If you didn't configure WxAPI, add the following code
        WXAPiHandler.setupWxApi("wxd930ea5d5a258f4f",this)
        //Get Ext-Info from Intent.
        FluwxRequestHandler.handleRequestInfoFromIntent(intent)
    }
```
如果你想自定义你的调用逻辑, 你需要在application中加上`<meta-data>`:
```xml
        <meta-data
            android:name="handleWeChatRequestByFluwx"
            android:value="flase" />
```
然后, 自己实现 `FluwxRequestHandler.customOnReqDelegate`.

> 更多信息请参考example.