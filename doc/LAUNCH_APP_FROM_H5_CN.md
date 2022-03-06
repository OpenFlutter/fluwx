## 从H5启动app
Fluwx 支持从`<wx-open-launch-app>`启动你的app, 并且支持传递`extInfo`给你的app.
对于Android来说,你要在`AndroidManifest.xml`中给你的`Activity`加上一个标签:
```
   <intent-filter>
       <action android:name="${applicationId}.FlutterActivity" />
       <category android:name="android.intent.category.DEFAULT" />
   </intent-filter>
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <data
        android:host="${applicationId}"
        android:path="/"
        android:scheme="wechatextmsg" />
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
            android:value="false" />
```
然后, 自己实现 `FluwxRequestHandler.customOnReqDelegate`.

## 兼容Android 11
请在你的应用的`AndroidManifest.xml`中添加以下queries:

```xml
<queries>
    <intent>
        <action android:name="${applicationId}.FlutterActivity" />
    </intent>
<intent>
    <action android:name="android.intent.action.VIEW" />
    <data
        android:host="${applicationId}"
        android:path="/"
        android:scheme="wechatextmsg" />
</intent>
</queries>
```

## IOS
请在你的`AppDelegate`中主动注册`WXApi`
```oc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //向微信注册
[[FluwxDelegate defaultManager] registerWxAPI:@"" universalLink:@""];
    return YES;
}
```

> 如你想主动获取从网页传进来的值 ，请主动调用`fluwx.getExtMsg()`。更多信息请参考example.

