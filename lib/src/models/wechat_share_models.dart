/*
 * Copyright (C) 2018 The OpenFlutter Organization
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../utils/utils.dart';
import '../wechat_type.dart';

const String _scene = "scene";
const String _transaction = "transaction";
const String _thumbnail = "thumbnail";
const String _title = "title";
const String _description = "description";
const String _messageExt = "messageExt";
const String _mediaTagName = "mediaTagName ";
const String _messageAction = "messageAction";

///Base Class for Sharing
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

///
/// [WeChatScene] is not supported here due to WeChat's limits.
/// the default value is [MINI_PROGRAM_TYPE_RELEASE]
///
class WeChatShareTextModel extends WeChatShareModel {
  final String text;
  final String transaction;

  ///transaction only works on  Android.
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

///
/// [WeChatScene] is not supported here due to WeChat's limits.
/// the default value is [MINI_PROGRAM_TYPE_RELEASE]
///
/// [hdImagePath] only works with iOS
///
class WeChatShareMiniProgramModel extends WeChatShareModel {
  final String webPageUrl;
  final WXMiniProgramType miniProgramType;
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
      WXMiniProgramType miniProgramType,
      this.userName,
      this.path: "/",
      this.title,
      this.description,
      this.thumbnail,
      this.withShareTicket: false,
      this.hdImagePath,
      String transaction,
      WeChatScene scene,
      String messageExt,
      String messageAction,
      String mediaTagName})
      : this.transaction = transaction ?? "miniProgram",
        this.miniProgramType = miniProgramType ?? WXMiniProgramType.RELEASE,
        assert(webPageUrl != null && webPageUrl.isNotEmpty),
        assert(userName != null && userName.isNotEmpty),
        assert(path != null && path.isNotEmpty),
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  @override
  Map toMap() {
    return {
      'webPageUrl': webPageUrl,
      "miniProgramType": miniProgramTypeToInt(miniProgramType),
      "userName": userName,
      "path": path,
      "title": title,
      "description": description,
      _transaction: transaction,
      _scene: scene.toString(),
      _thumbnail: thumbnail,
      "withShareTicket": withShareTicket,
      "hdImagePath": hdImagePath
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
  final Uint8List imageData;

  WeChatShareImageModel({
    String transaction,
    @required this.image,
    this.description,
    String thumbnail,
    WeChatScene scene,
    String messageExt,
    String messageAction,
    String mediaTagName,
    this.title,
  })  : this.transaction = transaction ?? "text",
        this.thumbnail = thumbnail ?? "",
        assert(image != null),
        this.imageData = null,
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  WeChatShareImageModel.fromFile(
    File imageFile, {
    String transaction,
    this.description,
    String thumbnail,
    WeChatScene scene,
    String messageExt,
    String messageAction,
    String mediaTagName,
    this.title,
  })  : this.image = "file://${imageFile.path}",
        this.transaction = transaction ?? "text",
        this.thumbnail = thumbnail ?? "",
        this.imageData = null,
        super(
            mediaTagName: mediaTagName,
            messageAction: messageAction,
            messageExt: messageExt,
            scene: scene);

  WeChatShareImageModel.fromUint8List({
    @required this.imageData,
    String transaction,
    this.description,
    String thumbnail,
    WeChatScene scene,
    String messageExt,
    String messageAction,
    String mediaTagName,
    this.title,
  })  : this.transaction = transaction ?? "text",
        this.thumbnail = thumbnail ?? "",
        this.image = "",
        assert(imageData != null),
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
      "imageData": imageData,
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

class WeChatShareFileModel extends WeChatShareModel {
  final String transaction;
  final String filePath;
  final String fileExtension;
  final String thumbnail;
  final String title;
  final String description;

  WeChatShareFileModel({
    String transaction,
    this.filePath,
    this.fileExtension: "pdf",
    this.title: "",
    this.description: "",
    String thumbnail,
    WeChatScene scene,
    String messageExt,
    String messageAction,
    String mediaTagName,
  })  : this.transaction = transaction ?? "text",
        this.thumbnail = thumbnail ?? "",
        assert(filePath != null),
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
      "filePath": filePath,
      "fileExtension": fileExtension,
      _thumbnail: thumbnail,
      _title: title,
      _description: description,
      _mediaTagName: mediaTagName,
      _messageAction: messageAction,
      _messageExt: messageExt,
    };
  }
}
