## 从H5启动app
Fluwx 支持从`<wx-open-launch-app>`启动你的app, 并且支持传递`extInfo`给你的app.
对于Android来说,你要在`AndroidManifest.xml`中给你的宿主`Activty`加上一个标签:
```
    <action android:name="${applicationId}.FlutterActivity" />
```
如果你想把`extInfo`传给Flutter, 你要在`MainActivity`加上如下代码:
```kotlin
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        //If you didn't configure WxAPI, add the following code
        WXAPiHandler.setupWxApi("wxd930ea5d5a258f4f",this)
        //Get Ext-Info from Intent.
        FluwxRequestHandler.handleRequestInfoFromIntent(intent)
    }
```
如果你想自定义你的调用逻辑, 你需要在宿主Activity中加上`<meta-data>`:
```xml
        <meta-data
            android:name="handleWeChatRequestByFluwx"
            android:value="flase" />
```
然后, 自己实现 `FluwxRequestHandler.customOnReqDelegate`.