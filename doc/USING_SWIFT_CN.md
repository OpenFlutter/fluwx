## 使用Swift?
`fluwx` 从*2.0.0*开始支持 `swift`。 但是在使用swift之前, 我们还有一些工作要做。
如果有人知道更好的方式，请告诉我或者提一个PR。

## Make Headers Public
由于`WeChatOpenSDK`用到了静态库，所以当我们编译swift的时候会报一个错误： `include non-modular headers`。
为了支持swift,我们不得不将`WeChatOpenSDK`里的头文件变成public的:

![make_headers_public](../arts/public_headers_1.png)

![make_headers_public](../arts/public_headers_2.png)


## 回调监听
在你的`AppDelegate.swift`文件中重写以下方法：
```swift

  import fluwx

  override  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: FluwxResponseHandler.defaultManager())
    }

    // NOTE: 9.0以后使用新API接口
  override  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: FluwxResponseHandler.defaultManager())
    }

```