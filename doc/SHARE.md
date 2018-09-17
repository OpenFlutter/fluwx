### Summary
`Fluwx` doesn't support all kind of sharing.Only text, image, web page,
music, video and mini program are supported.We'll consider the more.
More support will be considered in the future.
.


 >  NOTE：Images or thumbnails used for sharing only support `png`and`jpg`.Network or assets images are OK.<br>
 >  However,using images from `assets`,you have to add a schema `assets://`。<br>
 >  For assets image from  a particular package,you have to add a query param:`?package=package_name`<br>
 >  We consider support `file://` in the future,so paths begin with  `file://` are ok, but fluwx does nothing<br>
 >  If no schema or wrong schema proivided,fluwx will load it as network image.Be careful<br>
 >  Due to the limits of WeChat，the thumbnail must be smaller than 32k(mini-program's is smaller than 120k),you'd better provide <br>
 >  a qualified thumbnail.Otherwise, `Fluwx` will compress it for you. The result of compression is unpredictable.<br>
 >  Considering that we may obtain a path such as *content://media/external/file* on Android, `fluwx` also support reading image or thumbnail from `content://`.<br>
 >  `content://` only works on Android.
### The Destination
    The destination of sharing can be SESSION(default),TIMELINE or FAVORITE.However,mini-program only support SESSION.
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
### Return
 the return value of `fluwx.share(model)` is `Map`：
```dart
    {
       "platform":"Android",//or iOS
       result:true //or false，depends on WXApi.sendRequest()
     }
```

### Share Text
```dart
  fluwx.share(WeChatShareTextModel(
      text: "text from fluwx",
      transaction: "transaction}",
      scene: scene
    ));
```
### Share Image
```dart
 fluwx.share(WeChatShareImageModel(
        image: _imagePath,
        thumbnail: _thumbnail,
        transaction: _imagePath,
        scene: scene,
        description: "image"));
```
>  NOTE：`Fluwx` will create thumbnail from `image` if thumbnail isn't provided.

### Share Music
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
Two kind of music：`musicUrl`和`musicLowBandUrl`.They are not coexisting，if both are assigned, only`musicUrl` will be used.
### Share Video
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
Two kind of video:`videoUrl`和`videoLowBandUrl`.They are not coexisting，if both are assigned, only `videoUrl` will be used.
### Share Mini Program
```dart
 var model =new WeChatShareMiniProgramModel(
      webPageUrl: _webPageUrl,
      miniProgramType: WeChatShareMiniProgramModel.MINI_PROGRAM_TYPE_RELEASE,
      userName: _userName,
      title: _title,
      description: _description,
      thumbnail: _thumbnail
    );
    fluwx.share(model);
```
`miniProgramType` only suports the following values:
* MINI_PROGRAM_TYPE_RELEASE
* MINI_PROGRAM_TYPE_TEST
* MINI_PROGRAM_TYPE_PREVIEW
