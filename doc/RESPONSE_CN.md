### 微信调回
微信的回调也要根据平台的不同进行差异化处理(如果你不需要回调，请忽略)。


### Flutter
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

> 注意：如果一个字段以*android*或者*iOS*开头，那么意味这个字段只存在于*android*或者*iOS*。



### Android
从*0.4.0*开始，开发者不必手动添加`WXEntryActivity`和`WXPayEntryActivity`了，所以下面的不是必需要的了：
~~由于机制问题，`Android`端需要在`WXEntryActivity`或`WXPayEntryActivity`中添加如下代码：~~
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
~~你也可以直接继承`FluwxWXEntryActivity`。~~
~~`WXEntryActivity`和`WXPayEntryActivity`创建规则请参阅官方文档。具体可以参考[example wxapi](https://github.com/OpenFlutter/fluwx/tree/master/example/android/app/src/main/kotlin/net/sourceforge/simcpux/wxapi )~~
~~，也不要忘记在`AndroidManifest.mxl`中注册：~~
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


#### 但个性化总是好的
有的时候开者仍然需要手动创建`WXEntryActivity`和`WXPayEntryActivity`，比如这并不是一个纯净的Flutter的项目，仍有一部分需要
原生实现。`WXEntryActivity`and`WXPayEntryActivity` 必须在 *packageName/wxapi/*下面,方便起见，你可以直接继承 `FluwxWXEntryActivity` 。
然后在`AndroidManifest.mxl`中注册`WXEntryActivity`and`WXPayEntryActivity`:
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
从1.0.0开始以下作废
~~在你的`AppDelegate`中重写下面方法~~：
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

如果你一定要重写这两个方法, 那么请确认你调用了`super`:

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
  return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
  return [super application:application openURL:url options:options];
}
```
> 注意：为了能够返回你的app，请不要忘记添加URL Schema。
