## WeChat Not Installed on iOS?
if you have installed WeChat on your iPhone but you still catch an exception that "wechat not installed",just add the following
code to your *info.plist*:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
<string>weixin</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

## Can't Launch WeChat on Android?
Check your signature please.


## Failed to notify project evalution listener
[Failed to notify project evalution listener](https://www.jianshu.com/p/f74fed94be96)
