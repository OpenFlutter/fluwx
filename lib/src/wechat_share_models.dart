import 'package:wechat_plugin/src/wechat_scene.dart';

class WeChatShareTextModel {
  final String text;
  final String transaction;
  final WeChatScene scene;

  WeChatShareTextModel({String text, String transaction, WeChatScene scene})
      : this.text = text ?? "",
        this.transaction = transaction ?? "text",
        this.scene = scene ?? WeChatScene.TIMELINE;

  Map toMap() {
    return {
      "text": text,
      "transaction": transaction,
      "scene": scene.toString()
    };
  }
}



class WeChatMiniProgramModel {
  static const int MINI_PTOGRAM_TYPE_RELEASE = 0;
  static const int MINI_PROGRAM_TYPE_TEST = 1;
  static const int MINI_PROGRAM_TYPE_PREVIEW = 2;

  final WeChatScene scene = WeChatScene.SESSION;

  final String webPageUrl;
  final int miniProgramType;
  final String userName;
  final String path;

  final String title;

  final String description;

  final String transaction;

  final String thumbnail;

  WeChatMiniProgramModel(
      {this.webPageUrl,
      int miniProgramType,
      this.userName,
      this.path,
      this.title,
      this.description,
        this.thumbnail,
      String transaction})
      : this.transaction = transaction ?? "miniProgram",
      this.miniProgramType = miniProgramType??MINI_PTOGRAM_TYPE_RELEASE,
      assert(webPageUrl != null && webPageUrl.isNotEmpty),
      assert(userName != null && userName.isNotEmpty)    ,
      assert(path != null && path.isNotEmpty );

  Map toMap(){
    return {
      'webPageUrl':webPageUrl,
      "miniProgramType":miniProgramType,
      "userName":userName,
      "path":path,
      "title":title,
      "description":description,
      "transaction":transaction,
      "scene":scene,
      "thumbnail":thumbnail
    };
  }
}
