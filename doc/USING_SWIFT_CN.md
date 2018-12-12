## 使用Swift?
`fluwx` 从*0.2.0*开始支持 `swift`。



## 回调监听
在你的`AppDelegate.swift`文件中重写以下方法：
```swift
  //swift4.1
  import fluwx


  override  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: FluwxResponseHandler.defaultManager())
    }

    // NOTE: 9.0以后使用新API接口
  override  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: FluwxResponseHandler.defaultManager())
    }

```

```swift
  //swift4.2
  import fluwx

  //  Converted to Swift 4 by Swiftify v4.1.6841 - https://objectivec2swift.com/
  override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return WXApi.handleOpen(url, delegate: FluwxResponseHandler.defaultManager())
  }

  // NOTE: 9.0以后使用新API接口
  override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
      return WXApi.handleOpen(url, delegate: FluwxResponseHandler.defaultManager())
  }




```
