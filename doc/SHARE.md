## Share
Simple and easy:

```dart
 fluwx.share(WeChatShareTextModel("source text", scene: WeChatScene.SESSION));
```
The destination of sharing can be SESSION(default),TIMELINE or FAVORITE.However,mini-program only support SESSION.

```dart
    ///[WeChatScene.session]会话
    ///[WeChatScene.timeline]朋友圈
    ///[WeChatScene.favorite]收藏
    enum WeChatScene {
      session,
      timeline,
      favorite
      }
```

You can share these models:

- WeChatShareTextModel
- WeChatShareMiniProgramModel
- WeChatShareImageModel
- WeChatShareMusicModel
- WeChatShareVideoModel
- WeChatShareWebPageModel
- WeChatShareFileModel

