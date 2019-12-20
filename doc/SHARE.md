## Summary

`Fluwx` doesn't support all kind of sharing.Only text, image, web page,
music, video and mini program are supported.We'll consider the more.
More support will be considered in the future.
.

> NOTE：Images or thumbnails used for sharing only support `png`and`jpg`

### What kind of images are supported

- Network images
  
- Assets Images

- Local Images

- Uint8List
  
However, developers must care about the following points:

- Provide  schema `assets://` when using assets images.Query `?package=package_name` is neccessary when load images from particular package. Here's a full exmaple:`assets://path/to/your/image.png?package=fromPackage`
- Provide  schema `file://` or `content://` when using local images, but `content://` only works on Android due to `FileProvider`.For example, `content://media/external/file`
- Otherwise, network images by default.
- `Fluwx` will create thumbnail from main image if no thumbnail is provided. 
- Due to the limits of WeChat，the thumbnail must be smaller than 32k(mini-program's is 120k),  `Fluwx` will compress images before sharing if thumbnail is larger than that. But the result of compression is unpredictable.
    
 .Network or assets images are OK.<br>
 >  However,using images from `assets`,you have to add a schema `assets://path/to/your/image.png?package=fromPackage`。<br>
 >  For assets image from  a particular package,you have to add a query param:`?package=package_name`<br>
 >  If you want to use local image,`file://` must be provided.For example, a local image path should be "file://path/to/your/image.jpg". <br>
 >  If no schema or wrong schema provided,`Fluwx` will load it as network image.Be careful<br>
 >  Due to the limits of WeChat，the thumbnail must be smaller than 32k(mini-program's is smaller than 120k),you'd better provide <br>
 >  a qualified thumbnail.Otherwise, `Fluwx` will compress it for you. The result of compression is unpredictable.<br>
 >  Considering that we may obtain a path such as *content://media/external/file* on Android, `fluwx` also support reading image or thumbnail from `content://`.<br>
 >  `content://` only works on Android.

## The Destination
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



## Share Text
```dart
  fluwx.share(WeChatShareTextModel(
      text: "text from fluwx",
      transaction: "transaction}",
      scene: scene
    ));
```
## Share Image

```dart
 fluwx.share(WeChatShareImageModel(
        image: _imagePath,
        thumbnail: _thumbnail,
        transaction: _imagePath,
        scene: scene,
        description: "image"));
```
>  NOTE：`Fluwx` will create thumbnail from `image` if thumbnail isn't provided.

Well,let's talk about sharing big images on Android,if the image you want to share is smaller than 512k (the truth is the data passed through
`Intent`  must be smaller than 512k), everything works well.However, if it's bigger than
512k, take care the following permission:
```xml
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```
`Fluwx` can't share big images without  the permission above because these images will stored in:

```kotlin
 context.getExternalCacheDir()
```
Why? Because the limit of `Intent`. If someone knows a better solution,just PR or tell me.

## Share Music
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

## Share Video
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
Two kind of video:`videoUrl`和`videoLowBandUrl`.They are not coexisting，if both are assigned, only `videoUrl` will be used.

## Share Mini Program
```dart
 var model = fluwx.WeChatShareMiniProgramModel(
      webPageUrl: _webPageUrl,
      miniProgramType:fluwx.WXMiniProgramType.RELEASE,
      userName: _userName,
      title: _title,
      description: _description,
      thumbnail: _thumbnail
    );
    fluwx.share(model);
```

### Share File

```dart
 var model = fluwx.WeChatShareFileModel(
      filePath: _filePath,
      scene: scene,
      title: _title,
      description: _description
 );
 fluwx.share(model);
```
File size is limited and cannot exceed 10M

