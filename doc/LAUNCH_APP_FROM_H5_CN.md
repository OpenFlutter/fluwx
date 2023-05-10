
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

