## Launch App from H5
Fluwx supports launch app from `<wx-open-launch-app>`, and pass `extInfo` to your app.
For Android side, you need add the following action for your FlutterActivity in `AndroidManifest.xml`:
```
    <action android:name="${applicationId}.FlutterActivity" />
```
If you want to pass `extInfo` to Flutter, you need to add the following code in `MainActivity.kt`:
```kotlin
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        //If you didn't configure WxAPI, add the following code
        WXAPiHandler.setupWxApi("wxd930ea5d5a258f4f",this)
        //Get Ext-Info from Intent.
        FluwxRequestHandler.handleRequestInfoFromIntent(intent)
    }
```
If you want to custom your request logic, you need add the `<meta-data>` in host activity:
```xml
        <meta-data
            android:name="handleWeChatRequestByFluwx"
            android:value="flase" />
```
And then, set `FluwxRequestHandler.customOnReqDelegate` on your own.