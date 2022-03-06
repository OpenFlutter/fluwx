## Launch App from H5
Fluwx supports launch app from `<wx-open-launch-app>`, and pass `extInfo` to your app.
For Android side, you need add the following action for your FlutterActivity in `AndroidManifest.xml`:
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

At the same time, you also need to add `<meta-data>` in application which used to store your WeChat AppId:
```xml
        <meta-data
            android:name="weChatAppId"
            android:value="12345678" />

```

If you want to pass `extInfo` to Flutter, you need to add the following code in `MainActivity.kt`:
```kotlin
  override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //If you didn't configure WxAPI, add the following code
        WXAPiHandler.setupWxApi("wxd930ea5d5a258f4f",this)
        //Get Ext-Info from Intent.
        FluwxRequestHandler.handleRequestInfoFromIntent(intent)
    }
```
If you want to custom your request logic, you need add the `<meta-data>` in application:
```xml
        <meta-data
            android:name="handleWeChatRequestByFluwx"
            android:value="false" />
```
And then, set `FluwxRequestHandler.customOnReqDelegate` on your own.


## on Android 11
Please add the following queries in your app's `AndroidManifest.xml`:

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
Please register your WXApi in your `AppDelegate`:
```oc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //向微信注册
[[FluwxDelegate defaultManager] registerWxAPI:@"" universalLink:@""];
    return YES;
}
```

> If you want to get ext from website, please call ``fluwx.getExtMsg()`。`For details, please read the example.