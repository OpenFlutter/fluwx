## 简述

目前`Fluwx`并不是支持所有的分享类型，目前仅支持文本分享、图片分享、网址分享
    音乐、视频以及小程序的分享。未来会考虑增加更多支持。

### 都支持什么图片

- 网络图片
  
- Assets图片

- 本地图片

- Uint8List
  
但是, 需要注意以下几点:

- 如果使用Assets图片，请务必提供前缀 `assets://` .如果想加载指定包的图片请加上查询参数 `?package=package_name` 。 例子：`assets://path/to/your/image.png?package=fromPackage`。
- 如果使用本地图片，请务必提供前缀`file://` 或者 `content://`，但 `content://` 只在Android上有效，因为有的图片可能是从`FileProvider`得到的，例如, `content://media/external/file`
- 默认当作网络图片处理。
- 如果不提供缩略图，`Fluwx`将会尝试从主图片中创建缩略图。 
- 由于微信的限制，一般的缩略图要小于32k(小程序的缩略图要小于120k)，所以如果缩略图不符合规格，`Fluwx`将执行压缩。 其结果可能并不是你所预期的。

## 分享去处

绝大部分分享可以分享到会话，朋友圈，收藏（小程序目前只能分享到会话）。默认分享到会话。

```dart
    ///[WeChatScene.SESSION]会话
    ///[WeChatScene.TIMELINE]朋友圈
    ///[WeChatScene.FAVORITE]收藏
    enum WeChatScene {
      SESSION,
      TIMELINE,
      FAVORITE
      }
```

## 分享文本

```dart
  fluwx.share(fluwx.WeChatShareTextModel(
      text: "text from fluwx",
      transaction: "transaction}",//仅在android上有效，下同。
      scene: scene
    ));
```

## 分享图片

```dart
 fluwx.share(fluwx.WeChatShareImageModel(
        image: _imagePath,
        thumbnail: _thumbnail,
        transaction: _imagePath,
        scene: scene,
        description: "image"));
```

> 注意：如果不指定 `thumbnail`，那么`Fluwx`将尝试从`image`中获取缩略图。


好吧，让我们谈谈在Android上分享大图，如果说你要分享的图片小于512k（实际上是因为`Intent`传值是不能超过512k的），一切都可以正常工作。
但是如果你要分享的图片大于512k,那么请保证你的app有以下的权限：

```xml
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```
如果`Fluwx`没有以上的权限，那么是无法完成分享的，因为要分享的图片将会被存储在以下位置:

```kotlin
 context.getExternalCacheDir()
```
为什么? 因为`Intent`有限制. 如果有人知道更好的解决方案,请直接PR或者告诉我。

## 分享音乐

```dart
  var model = fluwx.WeChatShareMusicModel(
      title: _title,
      description: _description,
      transaction: "music",
      musicUrl: _musicUrl,
      musicLowBandUrl: _musicLowBandUrl
    );

    fluwx.share(model);
```

音乐的分享有两种：`musicUrl`和`musicLowBandUrl`。这两种形式是不共存的，如果
都二者都进行了赋值，那么只会读取`musicUrl`。

## 分享视频

```dart
   var model = fluwx.WeChatShareVideoModel(
     videoUrl: _videoUrl,
     transaction: "video",
     videoLowBandUrl: _videoLowBandUrl,
     thumbnail: _thumnail,
     description: _description,
     title: _title
   );
   fluwx.share(model);
```

视频的分享有两种：`videoUrl`和`videoLowBandUrl`。这两种形式是不共存的，如果
都二者都进行了赋值，那么只会读取`videoUrl`。

### 分享小程序

```dart
 var model = fluwx.WeChatShareMiniProgramModel(
      webPageUrl: _webPageUrl,
      miniProgramType: fluwx.WXMiniProgramType.RELEASE,
      userName: _userName,
      title: _title,
      description: _description,
      thumbnail: _thumbnail
    );
    fluwx.share(model);
```

### 分享文件

```dart
 var model = fluwx.WeChatShareFileModel(
      filePath: _filePath,
      scene: scene,
      title: _title,
      description: _description
 );
 fluwx.share(model);
```
文件有大小限制，不能超过10M；文件路径还要考虑权限