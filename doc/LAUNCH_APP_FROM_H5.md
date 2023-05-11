
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