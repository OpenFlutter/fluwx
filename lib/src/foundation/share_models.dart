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
const String _thumbnail = "thumbnail";
const String _title = "title";
const String _description = "description";
const String _messageExt = "messageExt";
const String _mediaTagName = "mediaTagName";
const String _messageAction = "messageAction";
const String _compressThumbnail = "compressThumbnail";
const String _msgSignature = "msgSignature";

sealed class WeChatShareModel with _Argument {}

/// [source] the text you want to send to WeChat
/// [scene] the target you want to send
class WeChatShareTextModel extends WeChatShareModel {
  WeChatShareTextModel(
    this.source, {
    this.scene = WeChatScene.session,
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    this.msgSignature,
    String? description,
    String? title,
  })  : title = title ?? source,
        description = description ?? source;

  final String source;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;
  final String? title;
  final String? description;
  final String? msgSignature;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        _source: source,
        _messageExt: messageExt,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _title: title,
        _description: description,
        _msgSignature: msgSignature
      };
}

/// the default value is [MINI_PROGRAM_TYPE_RELEASE]
/// [hdImagePath] only works on iOS, not sure the relationship
/// between [thumbnail] and [hdImagePath].
class WeChatShareMiniProgramModel extends WeChatShareModel {
  WeChatShareMiniProgramModel(
      {required this.webPageUrl,
      this.miniProgramType = WXMiniProgramType.release,
      required this.userName,
      this.path = "/",
      this.title,
      this.description,
      this.withShareTicket = false,
      required this.thumbnail,
      this.hdImagePath,
      this.mediaTagName,
      this.messageAction,
      this.messageExt,
      this.compressThumbnail = true,
      this.msgSignature})
      : assert(webPageUrl.isNotEmpty),
        assert(userName.isNotEmpty),
        assert(path.isNotEmpty);

  final String webPageUrl;
  final WXMiniProgramType miniProgramType;
  final String userName;
  final String path;
  final WeChatImage? hdImagePath;
  final String? title;
  final String? description;
  final WeChatImage thumbnail;
  final bool withShareTicket;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;
  final bool compressThumbnail;
  final String? msgSignature;

  @override
  Map<String, dynamic> get arguments => {
        'webPageUrl': webPageUrl,
        "miniProgramType": miniProgramType.value,
        "userName": userName,
        "path": path,
        "title": title,
        _description: description,
        "withShareTicket": withShareTicket,
        _thumbnail: thumbnail.toMap(),
        "hdImagePath": hdImagePath?.toMap(),
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _compressThumbnail: compressThumbnail,
        _msgSignature: msgSignature
      };
}

/// [source] the image you want to send to WeChat
/// [scene] the target you want to send
/// [thumbnail] the preview of your image, will be created from [scene] if null.
class WeChatShareImageModel extends WeChatShareModel {
  WeChatShareImageModel(this.source,
      {WeChatImage? thumbnail,
      this.title,
      this.scene = WeChatScene.session,
      this.description,
      this.mediaTagName,
      this.messageAction,
      this.messageExt,
      this.compressThumbnail = true,
      this.msgSignature})
      : thumbnail = thumbnail ?? source;

  final WeChatImage source;
  final WeChatImage thumbnail;
  final String? title;
  final WeChatScene scene;
  final String? description;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;
  final bool compressThumbnail;
  final String? msgSignature;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        _source: source.toMap(),
        _thumbnail: thumbnail.toMap(),
        _title: title,
        _description: description,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _compressThumbnail: compressThumbnail,
        _msgSignature: msgSignature
      };
}

/// if [musicUrl] and [musicLowBandUrl] are both provided,
/// only [musicUrl] will be used.
class WeChatShareMusicModel extends WeChatShareModel {
  WeChatShareMusicModel(
      {this.musicUrl,
      this.musicLowBandUrl,
      this.title = "",
      this.description = "",
      this.musicDataUrl,
      this.musicLowBandDataUrl,
      this.thumbnail,
      this.mediaTagName,
      this.messageAction,
      this.messageExt,
      this.scene = WeChatScene.session,
      this.compressThumbnail = true,
      this.msgSignature})
      : assert(musicUrl != null || musicLowBandUrl != null);

  final String? musicUrl;
  final String? musicDataUrl;
  final String? musicLowBandUrl;
  final String? musicLowBandDataUrl;
  final WeChatImage? thumbnail;
  final String? title;
  final String? description;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;
  final bool compressThumbnail;
  final String? msgSignature;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        "musicUrl": musicUrl,
        "musicDataUrl": musicDataUrl,
        "musicLowBandUrl": musicLowBandUrl,
        "musicLowBandDataUrl": musicLowBandDataUrl,
        _thumbnail: thumbnail?.toMap(),
        _title: title,
        _description: description,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _compressThumbnail: compressThumbnail,
        _msgSignature: msgSignature
      };
}

/// if [videoUrl] and [videoLowBandUrl] are both provided,
/// only [videoUrl] will be used.
class WeChatShareVideoModel extends WeChatShareModel {
  WeChatShareVideoModel(
      {this.scene = WeChatScene.session,
      this.videoUrl,
      this.videoLowBandUrl,
      this.title = "",
      this.description = "",
      this.thumbnail,
      this.mediaTagName,
      this.messageAction,
      this.messageExt,
      this.compressThumbnail = true,
      this.msgSignature})
      : assert(videoUrl != null || videoLowBandUrl != null),
        assert(thumbnail != null);

  final String? videoUrl;
  final String? videoLowBandUrl;
  final WeChatImage? thumbnail;
  final String? title;
  final String? description;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;
  final bool compressThumbnail;
  final String? msgSignature;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        "videoUrl": videoUrl,
        "videoLowBandUrl": videoLowBandUrl,
        _thumbnail: thumbnail?.toMap(),
        _title: title,
        _description: description,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _compressThumbnail: compressThumbnail,
        _msgSignature: msgSignature
      };
}

/// [webPage] url you want to send to wechat
/// [thumbnail] logo of your website
class WeChatShareWebPageModel extends WeChatShareModel {
  WeChatShareWebPageModel(
    this.webPage, {
    this.title = "",
    String? description,
    this.thumbnail,
    this.scene = WeChatScene.session,
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    this.msgSignature,
    this.compressThumbnail = true,
  })  : assert(webPage.isNotEmpty),
        description = description ?? webPage;

  final String webPage;
  final WeChatImage? thumbnail;
  final String title;
  final String description;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;
  final bool compressThumbnail;
  final String? msgSignature;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        "webPage": webPage,
        _thumbnail: thumbnail?.toMap(),
        _title: title,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _description: description,
        _compressThumbnail: compressThumbnail,
        _msgSignature: msgSignature
      };
}

/// [source] the file you want to share, [source.suffix] is necessary on iOS.
/// [scene] can't be [WeChatScene.TIMELINE], otherwise, sharing nothing.
/// send files to WeChat
class WeChatShareFileModel extends WeChatShareModel {
  WeChatShareFileModel(
    this.source, {
    this.title = "",
    this.description = "",
    this.thumbnail,
    this.scene = WeChatScene.session,
    this.mediaTagName,
    this.messageAction,
    this.messageExt,
    this.msgSignature,
    this.compressThumbnail = true,
  });

  final WeChatFile source;
  final WeChatImage? thumbnail;
  final String title;
  final String description;
  final WeChatScene scene;
  final String? messageExt;
  final String? messageAction;
  final String? mediaTagName;
  final bool compressThumbnail;
  final String? msgSignature;

  @override
  Map<String, dynamic> get arguments => {
        _scene: scene.index,
        _source: source.toMap(),
        _thumbnail: thumbnail?.toMap(),
        _title: title,
        _description: description,
        _messageAction: messageAction,
        _mediaTagName: mediaTagName,
        _compressThumbnail: compressThumbnail,
        _msgSignature: msgSignature
      };
}
