## 分享
简单:

```dart
 fluwx.share(WeChatShareTextModel("source text", scene: WeChatScene.SESSION));
```
绝大部分分享可以分享到会话，朋友圈，收藏（小程序目前只能分享到会话）。默认分享到会话。

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


支持的分享各类:

- WeChatShareTextModel
- WeChatShareMiniProgramModel
- WeChatShareImageModel
- WeChatShareMusicModel
- WeChatShareVideoModel
- WeChatShareWebPageModel
- WeChatShareFileModel

