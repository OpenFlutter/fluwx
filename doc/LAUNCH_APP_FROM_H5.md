## WeChat reference document

- [WeChat open label jumps to APP: &lt;wx-open-launch-app&gt;](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/Wechat_Open_Tag.html#%E8%B7%B3%E8%BD%ACAPP%EF%BC%9Awx-open-launch-app)
- [App gets the extinfo data in the open tag <wx-open-launch-app>](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/APP_GET_EXTINF.html)

## Platform differences

- The event type of **Launch-App-From-H5** on Android is `WeChatShowMessageFromWXRequest`
- The event type of **Launch-App-From-H5** on IOS is `WeChatLaunchFromWXRequest`

## Example

```dart
void handle_launch_from_h5() {
  Fluwx fluwx = Fluwx();

  fluwx.addSubscriber((response) {
    // 1. Handle responses separately for android and ios
    if (response is WeChatShowMessageFromWXRequest) {
      debugPrint("launch-app-from-h5 on android");
      // do something here only for android after launch from wechat
    } else if (response is WeChatLaunchFromWXRequest) {
      debugPrint("launch-app-from-h5 on ios");
      // do something here only for android after launch from wechat
    }

    // 2. Or handling responses together for android and ios
    if (response is WeChatLaunchFromWXRequest ||
        response is WeChatShowMessageFromWXRequest) {
      debugPrint("launch-app-from-h5");
      // do something here for both android and ios after launch from wechat
    }
  });
}
```

> If you want to get ext from website, please call `fluwx.getExtMsg()`。For details, please read the example project.
