/*
 * Copyright (c) 2023.  OpenFlutter Project
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  The ASF licenses this
 * file to you under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

part of 'arguments.dart';

const String _scene = "scene";
const String _source = "source";
const String _title = "title";
const String _description = "description";
const String _messageExt = "messageExt";
const String _mediaTagName = "mediaTagName";
const String _messageAction = "messageAction";
const String _msgSignature = "msgSignature";
const String _thumbData = "thumbData";
const String _thumbDataHash = "thumbDataHash";

sealed class WeChatShareModel with _Argument {
  final String? title;
  final String? description;
  final Uint8List? thumbData;
  final String? thumbDataHash;
  final String? msgSignature;

  WeChatShareModel(
      {required this.title,
      required this.description,
      required this.thumbData,
      required this.thumbDataHash,
      required this.msgSignature});
}

/// [source] the text you want to send to WeChat
/// [scene] the target you want to send
class WeChatShareTextModel extends WeChatShareModel {
  WeChatShareTextModel(
    this.source, {
    this.scene = WeChatScene.session,
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    super.msgSignature,
    super.thumbData,
    super.thumbDataHash,
    String? description,
    String? title,
  }) : super(
          title: title ?? source,
          description: description ?? source,
        );

  final String source;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        _source: source,
        _messageExt: messageExt,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _title: title,
        _description: description,
        _msgSignature: msgSignature,
        _thumbData: thumbData,
        _thumbDataHash: thumbDataHash,
      };
}

/// [hdImageData] only works on iOS, not sure the relationship
/// the default value is [MINI_PROGRAM_TYPE_RELEASE]
class WeChatShareMiniProgramModel extends WeChatShareModel {
  WeChatShareMiniProgramModel({
    required this.webPageUrl,
    this.miniProgramType = WXMiniProgramType.release,
    required this.userName,
    this.path = "/",
    super.title,
    super.description,
    this.withShareTicket = false,
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    this.hdImageData,
    super.msgSignature,
    super.thumbData,
    super.thumbDataHash,
  })  : assert(webPageUrl.isNotEmpty),
        assert(userName.isNotEmpty),
        assert(path.isNotEmpty);

  final Uint8List? hdImageData;
  final String webPageUrl;
  final WXMiniProgramType miniProgramType;
  final String userName;
  final String path;
  final bool withShareTicket;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;

  @override
  Map<String, dynamic> get arguments => {
        'webPageUrl': webPageUrl,
        "miniProgramType": miniProgramType.value,
        "userName": userName,
        "path": path,
        "title": title,
        _description: description,
        "withShareTicket": withShareTicket,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _msgSignature: msgSignature,
        _thumbData: thumbData,
        _thumbDataHash: thumbDataHash,
        "hdImageData": hdImageData,
      };
}

/// [source] the image you want to send to WeChat
/// [scene] the target you want to send
class WeChatShareImageModel extends WeChatShareModel {
  WeChatShareImageModel(
    this.source, {
    this.entranceMiniProgramPath,
    this.entranceMiniProgramUsername,
    super.title,
    this.scene = WeChatScene.session,
    super.description,
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    super.msgSignature,
    super.thumbData,
    super.thumbDataHash,
  });

  final WeChatImageToShare source;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;
  final String? entranceMiniProgramUsername;
  final String? entranceMiniProgramPath;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        _source: source.arguments,
        _title: title,
        _description: description,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _msgSignature: msgSignature,
        _thumbData: thumbData,
        _thumbDataHash: thumbDataHash,
        "entranceMiniProgramUsername": entranceMiniProgramUsername,
        "entranceMiniProgramPath": entranceMiniProgramPath,
      };
}

/// if [musicUrl] and [musicLowBandUrl] are both provided,
/// only [musicUrl] will be used.
class WeChatShareMusicModel extends WeChatShareModel {
  WeChatShareMusicModel(
      {this.musicUrl,
      this.musicLowBandUrl,
      super.title = "",
      super.description = "",
      this.musicDataUrl,
      this.musicLowBandDataUrl,
      this.mediaTagName,
      this.messageAction,
      this.messageExt,
      this.scene = WeChatScene.session,
      super.msgSignature,
      super.thumbData,
      super.thumbDataHash})
      : assert(musicUrl != null || musicLowBandUrl != null);

  final String? musicUrl;
  final String? musicDataUrl;
  final String? musicLowBandUrl;
  final String? musicLowBandDataUrl;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        "musicUrl": musicUrl,
        "musicDataUrl": musicDataUrl,
        "musicLowBandUrl": musicLowBandUrl,
        "musicLowBandDataUrl": musicLowBandDataUrl,
        _title: title,
        _description: description,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _msgSignature: msgSignature,
        _thumbData: thumbData,
        _thumbDataHash: thumbDataHash,
      };
}

/// if [videoUrl] and [videoLowBandUrl] are both provided,
/// only [videoUrl] will be used.
class WeChatShareVideoModel extends WeChatShareModel {
  WeChatShareVideoModel({
    this.scene = WeChatScene.session,
    this.videoUrl,
    this.videoLowBandUrl,
    super.title = "",
    super.description = "",
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    super.msgSignature,
    super.thumbData,
    super.thumbDataHash,
  }) : assert(videoUrl != null || videoLowBandUrl != null);

  final String? videoUrl;
  final String? videoLowBandUrl;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        "videoUrl": videoUrl,
        "videoLowBandUrl": videoLowBandUrl,
        _title: title,
        _description: description,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _msgSignature: msgSignature,
        _thumbData: thumbData,
        _thumbDataHash: thumbDataHash,
      };
}

/// [webPage] url you want to send to wechat
/// [thumbnail] logo of your website
class WeChatShareWebPageModel extends WeChatShareModel {
  WeChatShareWebPageModel(
    this.webPage, {
    super.title = "",
    super.description,
    this.scene = WeChatScene.session,
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    super.msgSignature,
    super.thumbData,
    super.thumbDataHash,
  }) : assert(webPage.isNotEmpty);

  final String webPage;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        "webPage": webPage,
        _title: title,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _description: description,
        _msgSignature: msgSignature,
        _thumbData: thumbData,
        _thumbDataHash: thumbDataHash,
      };
}

/// [source] the file you want to share, [source.suffix] is necessary on iOS.
/// [scene] can't be [WeChatScene.TIMELINE], otherwise, sharing nothing.
/// send files to WeChat
class WeChatShareFileModel extends WeChatShareModel {
  WeChatShareFileModel(
    this.source, {
    super.title = "",
    super.description = "",
    this.scene = WeChatScene.session,
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    super.msgSignature,
    super.thumbData,
    super.thumbDataHash,
  });

  final WeChatFile source;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        _source: source.toMap(),
        _title: title,
        _description: description,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _msgSignature: msgSignature,
        _thumbData: thumbData,
        _thumbDataHash: thumbDataHash,
      };
}

class WeChatImageToShare with _Argument {
  final Uint8List? uint8List;
  final String? localImagePath;
  final String? imgDataHash;

  /// [uint8List] is available on both  iOS and Android
  /// [localImagePath] only available on  Android, if [uint8List] is null, [localImagePath] must not be null;
  /// if [uint8List] and [localImagePath] are both provided on android, [uint8List] will be used.
  /// If [localImagePath] starts with content://, it will be treated as a content provider uri and please ensure
  /// you have already granted the app the permission to read the content. Otherwise, please ensure the file is
  /// accessible by the app.
  WeChatImageToShare({this.uint8List, this.localImagePath, this.imgDataHash}) {
    if (Platform.isIOS) {
      assert(uint8List != null);
    }

    if (Platform.isAndroid) {
      assert(uint8List != null || localImagePath != null);
    }
  }

  @override
  Map<String, dynamic> get arguments => {
        'uint8List': uint8List,
        'localImagePath': localImagePath,
        'imgDataHash': imgDataHash,
      };
}
