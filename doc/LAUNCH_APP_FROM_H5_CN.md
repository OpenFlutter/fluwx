## 微信参考文档

- [微信开放标签 &lt;wx-open-launch-app&gt; 跳转App](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/Wechat_Open_Tag.html#%E8%B7%B3%E8%BD%ACAPP%EF%BC%9Awx-open-launch-app)
- [App获取开放标签 &lt;wx-open-launch-app&gt; 中的 extinfo 数据](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/APP_GET_EXTINF.html)

## 平台差异

- 安卓端 **微信唤起App** 的事件类型为 `WeChatShowMessageFromWXRequest`
- IOS端 **微信唤起App** 的事件类型为 `WeChatLaunchFromWXRequest`

## 示例

```dart
void handle_launch_from_h5() {
  Fluwx fluwx = Fluwx();

  fluwx.addSubscriber((response) {
    // 1. 为安卓和ios分开处理响应
    if (response is WeChatShowMessageFromWXRequest) {
      debugPrint("launch-app-from-h5 on android");
      // 从微信启动后，在这里只为 android 做一些事情
    } else if (response is WeChatLaunchFromWXRequest) {
      debugPrint("launch-app-from-h5 on ios");
      // 从微信启动后，在这里只为 ios 做一些事情
    }

    // 2. 或者为安卓和ios一起处理响应
    if (response is WeChatLaunchFromWXRequest ||
        response is WeChatShowMessageFromWXRequest) {
      debugPrint("launch-app-from-h5");
      // 从微信启动后，在这里为 android 和 ios 做一些事情
    }
  });
}
```

> 如你想主动获取从网页传进来的值 ，请主动调用`fluwx.getExtMsg()`。更多信息请参考example项目.
