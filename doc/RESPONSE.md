### Response From WeChat
There's some work we have to do on the particular platform(if you don't need this,just ignore).



### Flutter
We can get the reponse from WeChat after sharing and etc:
```dart
       fluwx.responseFromShare.listen((response){
         //do something
       });
       fluwx.responseFromAuth.listen((response){
         //do something
       });
       fluwx.responseFromPayment.listen((response){
         //do something
       });
```
> NOTE:If the field starts with "android" or "iOS", it means that only android or iOS has the field.

The type of return value is `WeChatResponse`，and  `type` is an enum:
```dart
enum WeChatResponseType {
    SHARE,
    AUTH,
    PAYMENT }
```





### Android
Fluwx will create `WXEntryActivity`or`WXPayEntryActivity` by itself since *0.4.0*. So the following
code isn't necessary.

~~For`Android`,create `WXEntryActivity`or`WXPayEntryActivity`,and override the following function：~~
```kotlin

     public override fun onCreate(savedInstanceState: Bundle?) {
          super.onCreate(savedInstanceState)

          WXAPiHandler.wxApi?.handleIntent(intent, this)
      }

      override fun onNewIntent(intent: Intent) {
          super.onNewIntent(intent)

          setIntent(intent)
          WXAPiHandler.wxApi?.handleIntent(intent, this)
      }


      override fun onResp(resp: BaseResp) {

          FluwxResponseHandler.handleResponse(resp)
          finish()
      }
```
~~You can also directly inherit `FluwxWXEntryActivity`,and then you can do nothing.
For the rule of creating `WXEntryActivity` and `WXPayEntryActivity`,please read [example wxapi](https://github.com/OpenFlutter/fluwx/tree/master/example/android/app/src/main/kotlin/net/sourceforge/simcpux/wxapi )~~
~~，never forget to register your Activity in `AndroidManifest.mxl`:~~
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
#### However Customization Is Always Good
Well, sometimes you need to create `WXEntryActivity`and`WXPayEntryActivity` by yourself because your project isn't
a pure-flutter-project. The `WXEntryActivity`and`WXPayEntryActivity` must be under *packageName/wxapi/*,you
can inherit `FluwxWXEntryActivity` for convenience.Then register `WXEntryActivity`and`WXPayEntryActivity`in
 `AndroidManifest.mxl`:
 ```
   <activity android:name=".wxapi.WXEntryActivity"
             android:theme="@style/DisablePreviewTheme"
             />
         <activity android:name=".wxapi.WXPayEntryActivity"
             android:theme="@style/DisablePreviewTheme"/>
         <activity-alias
             android:name="${applicationId}.wxapi.WXEntryActivity"
             android:exported="true"
             tools:replace="android:targetActivity"
             android:targetActivity=".wxapi.WXEntryActivity"
             android:launchMode="singleTop">

             <intent-filter>
                 <action android:name="android.intent.action.VIEW" />
                 <category android:name="android.intent.category.DEFAULT" />
                 <data android:scheme="sdksample" />
             </intent-filter>
         </activity-alias>
         <activity-alias
             tools:replace="android:targetActivity"
             android:name="${applicationId}.wxapi.WXPayEntryActivity"
             android:exported="true"
             android:targetActivity=".wxapi.WXPayEntryActivity"
             android:launchMode="singleTop">

             <intent-filter>
                 <action android:name="android.intent.action.VIEW" />
                 <category android:name="android.intent.category.DEFAULT" />
                 <data android:scheme="sdksample" />
             </intent-filter>
         </activity-alias>

 ```
### iOS
don't override this since 1.0.0:
~~override the following function in`AppDelegate`:~~
```objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

```

If you have to override these two functions, please make sure you have called `super`:

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
  return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
  return [super application:application openURL:url options:options];
}
```

> NOTE:Don't forget to add URL Schema in order to go back to  your app.


