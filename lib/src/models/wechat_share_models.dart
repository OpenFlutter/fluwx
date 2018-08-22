import 'package:flutter/material.dart';

import '../wechat_scene.dart';

const String _scene = "scene";
const String _transaction = "transaction";
const String _thumbnail = "thumbnail";
const String _title = "title";
const String _description = "description";
const String _messageExt = "messageExt";
const String _mediaTagName = "mediaTagName ";
const String _messageAction = "messageAction";

abstract class WeChatShareModel {
  final String messageExt;
  final String messageAction;
  final String mediaTagName;
  final WeChatScene scene;

  WeChatShareModel(
      {this.messageExt,
      this.messageAction,
      this.mediaTagName,
      this.scene: WeChatScene.SESSION});

  Map toMap();
}

class WeChatShareTextModel extends WeChatShareModel {
  final String text;
  final String transaction;

  WeChatShareTextModel(
      {String text,
      String transaction,
      WeChatScene scene,
      String messageExt,
      String messageAction,
      String mediaTagName})
      : this.text = text ?? "",
        this.transaction = transaction ?? "text",
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  @override
  Map toMap() {
    return {
      "text": text,
      _transaction: transaction,
      _scene: scene.toString(),
      _messageExt: messageExt,
      _messageAction: messageAction,
      _mediaTagName: mediaTagName
    };
  }
}

class WeChatShareMiniProgramModel extends WeChatShareModel {
  static const int MINI_PROGRAM_TYPE_RELEASE = 0;
  static const int MINI_PROGRAM_TYPE_TEST = 1;
  static const int MINI_PROGRAM_TYPE_PREVIEW = 2;

  final String webPageUrl;
  final int miniProgramType;
  final String userName;
  final String path;

  final String title;

  final String description;

  final String transaction;

  final String thumbnail;

  final String hdImagePath;

  final bool withShareTicket;

  ///[hdImagePath] only works on iOS.
  WeChatShareMiniProgramModel(
      {@required this.webPageUrl,
      int miniProgramType,
      this.userName,
      this.path: "/",
      this.title,
      this.description,
      this.thumbnail,
        this.withShareTicket:false,
        this.hdImagePath,
      String transaction,
      WeChatScene scene,
      String messageExt,
      String messageAction,
      String mediaTagName})
      : this.transaction = transaction ?? "miniProgram",
        this.miniProgramType = miniProgramType ?? MINI_PROGRAM_TYPE_RELEASE,
        assert(webPageUrl != null && webPageUrl.isNotEmpty),
        assert(userName != null && userName.isNotEmpty),
        assert(path != null && path.isNotEmpty),
        assert(miniProgramType < 3 && miniProgramType > -1),
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  @override
  Map toMap() {
    return {
      'webPageUrl': webPageUrl,
      "miniProgramType": miniProgramType,
      "userName": userName,
      "path": path,
      "title": title,
      "description": description,
      _transaction: transaction,
      _scene: scene.toString(),
      _thumbnail: thumbnail,
      "withShareTicket":withShareTicket,
      "hdImagePath":hdImagePath
    };
  }
}

///[image] can't be null.
///if [thumbnail] is null or blank,fluwx will create a thumbnail through [image]
class WeChatShareImageModel extends WeChatShareModel {
  final String transaction;
  final String image;
  final String thumbnail;
  final String title;
  final String description;

  WeChatShareImageModel(
      {String transaction,
      @required this.image,
      this.description,
      String thumbnail,
      WeChatScene scene,
      String messageExt,
      String messageAction,
      String mediaTagName,
      this.title})
      : this.transaction = transaction ?? "text",
        this.thumbnail = thumbnail ?? "",
        assert(image != null),
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  @override
  Map toMap() {
    return {
      _transaction: transaction,
      _scene: scene.toString(),
      "image": image,
      _thumbnail: thumbnail,
      _mediaTagName: mediaTagName,
      _messageAction: messageAction,
      _messageExt: messageExt,
      _title: title,
      _description: description
    };
  }
}

/// if [musicUrl] and [musicLowBandUrl] are both provided,
/// only [musicUrl] will be used.
class WeChatShareMusicModel extends WeChatShareModel {
  final String transaction;
  final String musicUrl;
  final String musicDataUrl;
  final String musicLowBandUrl;
  final String musicLowBandDataUrl;
  final String thumbnail;
  final String title;
  final String description;

  WeChatShareMusicModel({
    String transaction,
    this.musicUrl,
    this.musicLowBandUrl,
    this.title: "",
    this.description: "",
    this.musicDataUrl,
    this.musicLowBandDataUrl,
    String thumbnail,
    WeChatScene scene,
    String messageExt,
    String messageAction,
    String mediaTagName,
  })  : this.transaction = transaction ?? "text",
        this.thumbnail = thumbnail ?? "",
        assert(musicUrl != null || musicLowBandUrl != null),
        assert(thumbnail != null),
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  @override
  Map toMap() {
    return {
      _transaction: transaction,
      _scene: scene.toString(),
      "musicUrl": musicUrl,
      "musicDataUrl": musicDataUrl,
      "musicLowBandUrl": musicLowBandUrl,
      "musicLowBandDataUrl": musicLowBandDataUrl,
      _thumbnail: thumbnail,
      _title: title,
      _description: description,
      _mediaTagName: mediaTagName,
      _messageAction: messageAction,
      _messageExt: messageExt,
    };
  }
}
/// if [videoUrl] and [videoLowBandUrl] are both provided,
/// only [videoUrl] will be used.
class WeChatShareVideoModel extends WeChatShareModel {
  final String transaction;
  final String videoUrl;
  final String videoLowBandUrl;
  final String thumbnail;
  final String title;
  final String description;

  final String messageExt;
  final String messageAction;
  final String mediaTagName;

  WeChatShareVideoModel({
    String transaction,
    WeChatScene scene,
    this.videoUrl,
    this.videoLowBandUrl,
    this.title: "",
    this.description: "",
    String thumbnail,
    this.messageExt,
    this.messageAction,
    this.mediaTagName,
  })  : this.transaction = transaction ?? "text",
        this.thumbnail = thumbnail ?? "",
        assert(videoUrl != null || videoLowBandUrl != null),
        assert(thumbnail != null),
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  @override
  Map toMap() {
    return {
      _transaction: transaction,
      _scene: scene.toString(),
      "videoUrl": videoUrl,
      "videoLowBandUrl": videoLowBandUrl,
      _thumbnail: thumbnail,
      _title: title,
      _description: description,
      _mediaTagName: mediaTagName,
      _messageAction: messageAction,
      _messageExt: messageExt,
    };
  }
}

class WeChatShareWebPageModel extends WeChatShareModel {
  final String transaction;
  final String webPage;
  final String thumbnail;
  final String title;
  final String description;

  WeChatShareWebPageModel({
    String transaction,
    @required this.webPage,
    this.title: "",
    this.description: "",
    this.thumbnail,
    WeChatScene scene,
    String messageExt,
    String messageAction,
    String mediaTagName,
  })  : this.transaction = transaction ?? "text",
        assert(webPage != null),
        assert(thumbnail != null),
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  @override
  Map toMap() {
    return {
      _transaction: transaction,
      _scene: scene.toString(),
      "webPage": webPage,
      _thumbnail: thumbnail,
      _title: title,
      _description: description,
      _mediaTagName: mediaTagName,
      _messageAction: messageAction,
      _messageExt: messageExt,
    };
  }
}
