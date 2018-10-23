### 简述
目前`Fluwx`并不是支持所有的分享类型，目前仅支持文本分享、图片分享、网址分享
    音乐、视频以及小程序的分享。未来会考虑增加更多支持。


 >  注意：目前分享中涉及到图片的地方仅支持`png`和`jpg`，支持网络图片及`assets`图片。<br>
 >  使用`assets`图片需要添加`assets://`。<br>
 >  也可以在`assets`图片添加`?package=package_name`以读取指定包的图片。<br>
 >  如果你想使用本地图片请勿必提供`file://`，比如`file://path/to/your/image.jpg`。<br>
 >  如果不指定schema或者schema错误,将会被处理为网络图片，请谨慎。<br>
 >  由于微信的限制，一般的缩略图要小于32k(小程序的缩略图要小于120k)，所以在使用缩略的时候<br>
 >  很有必要使用一张合格的缩略图，否则`Fluwx`进行压缩，其结果可能并不是你所预期的。
 >  考虑到在`Android`上，我们可能得到像*content://media/external/file*这样的路径, `fluwx` 也支持从`content://`中读取图片或者缩略图.<br>
 >  `content://` 只在Android上有效。

### 分享去处
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
### 返回值处理
 `fluwx.share(model)`返回的是一个`Map`：
```dart
    {
       "platform":"Android",//或者iOS
       result:true //或者false，取决于WXApi.sendRequest()的结果
     }
```

### 分享文本
```dart
  fluwx.share(WeChatShareTextModel(
      text: "text from fluwx",
      transaction: "transaction}",//仅在android上有效，下同。
      scene: scene
    ));
```
### 分享图片
```dart
 fluwx.share(WeChatShareImageModel(
        image: _imagePath,
        thumbnail: _thumbnail,
        transaction: _imagePath,
        scene: scene,
        description: "image"));
```
>  注意：如果不指定 `thumbnail`，那么`Fluwx`将尝试从`image`中获取缩略图。

### 分享音乐
```dart
  var model = WeChatShareMusicModel(
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
### 分享视频
```dart
   var model = new WeChatShareVideoModel(
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
 var model =new WeChatShareMiniProgramModel(
      webPageUrl: _webPageUrl,
      miniProgramType: fluwx.WXMiniProgramType.RELEASE,
      userName: _userName,
      title: _title,
      description: _description,
      thumbnail: _thumbnail
    );
    fluwx.share(model);
```
