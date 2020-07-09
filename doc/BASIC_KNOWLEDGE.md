## Basic knowledge

### Response from WeChat
Actually, almost every result from functions like `shareToWeChat` or `payWithWeChat` which call `sendRequest` in native doesn't makes sense. The `bool` value is the result of `sendRequest`.
So if you want get the real result you shall do like this:

```dart
  weChatResponseEventHandler.listen((res) {
      if (res is WeChatPaymentResponse) {
          // do something here
      }
    });
```
Take a look at subclasses of `BaseWeChatResponse` for help.

> NOTE: If you get `errCode = -1`, please read the WeChatSDK document for help. There are to many cases lead to that.

### Images in WeChat

The are four built-in types  of  `WeChatImage` in `fluwx`:

```dart
  WeChatImage.network(String source, {String suffix});
  WeChatImage.file(File source, {String suffix = ".jpeg"});
  WeChatImage.asset(String source, {String suffix});
  WeChatImage.binary(Uint8List source, {String suffix = ".jpeg"});
```

The priority of `suffix` is highest, `fluwx` will try to read suffix from paths if `suffix` is blank.

The max size of image youcan share to WeChat is `10M`.`Fluwx` wil compress `WeChatImage` itself if it's  used as `thumbnail` or `hdImagePath`,  
otherwise, it doesn't. However, you'd better compress thumbnail yourself as the result of compression is unpredictable.
