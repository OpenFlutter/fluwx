
import 'package:wechat_plugin/src/wechat_scene.dart';

class WeChatShareTextModel{
  final String text;
  final String transaction;
  final WeChatScene  scene;


  WeChatShareTextModel({
    String text,
    String transaction,
    WeChatScene scene}):
        this.text = text??"",
        this.transaction = transaction??"text",
        this.scene = scene ?? WeChatScene.TIMELINE;

  Map toMap(){
    return {"text":text,"transaction":transaction,"scene":scene.toString()};
  }
}