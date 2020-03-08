## Share
Simple and easy:

```dart
 shareToWeChat(WeChatShareTextModel("source text", scene: WeChatScene.SESSION));
```
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

You can share these models:

- WeChatShareTextModel
- WeChatShareMiniProgramModel
- WeChatShareImageModel
- WeChatShareMusicModel
- WeChatShareVideoModel
- WeChatShareWebPageModel
- WeChatShareFileModel

