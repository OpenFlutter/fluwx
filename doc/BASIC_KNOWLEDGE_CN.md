## 基础知识

### 微信回调

实际上，像`shareToWeChat` or `payWithWeChat`这种的函数，底层上是调用了原生SDK的`sendRequest`方法，所以他们的返回结果意义不大，他们的返回结果仅仅是`sendRequest`的返回值。
为了获取真实的回调，你应该这样做：

```dart
  weChatResponseEventHandler.listen((res) {
      if (res is WeChatPaymentResponse) {
          // do something here
      }
    });
```

> 笔记: 如果你的 `errCode = -1`, 那请阅读微信官方文档，因为-1的原因数不胜数.

### 图片

有四种内置 `WeChatImage`:

```dart
  WeChatImage.network(String source, {String suffix});
  WeChatImage.file(File source, {String suffix = ".jpeg"});
  WeChatImage.asset(String source, {String suffix});
  WeChatImage.binary(Uint8List source, {String suffix = ".jpeg"});
```

其中， `suffix` 优先级最高, 如果`suffix`是空白的，`fluwx` 将会尝试从文件路径中读取后缀.

在分享图片的功能，图片不能超过`10M`.如果图片被用作`thumbnail` 或 `hdImagePath`，`Fluwx` 会对 `WeChatImage` 进行压缩,  
否则不会压缩. 但是，最好还是自己压缩，因为不保证`fluwx`压缩效果。
