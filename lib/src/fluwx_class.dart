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
import 'dart:async';

import 'package:flutter/services.dart';

import 'models/wechat_pay_model.dart';
import 'models/wechat_response.dart';
import 'models/wechat_send_auth_model.dart';
import 'models/wechat_share_models.dart';

StreamController<WeChatResponse> _responseController =
    new StreamController.broadcast();

final MethodChannel _channel = const MethodChannel('com.jarvanmo/fluwx')
  ..setMethodCallHandler(_handler);

Future<dynamic> _handler(MethodCall methodCall) {
  if ("onShareResponse" == methodCall.method) {
    _responseController
        .add(WeChatResponse(methodCall.arguments, WeChatResponseType.SHARE));
  } else if ("onAuthResponse" == methodCall.method) {
    _responseController
        .add(WeChatResponse(methodCall.arguments, WeChatResponseType.AUTH));
  } else if ("onPayResponse" == methodCall.method) {
    _responseController
        .add(WeChatResponse(methodCall.arguments, WeChatResponseType.PAYMENT));
  }

  return Future.value(true);
}

class Fluwx {
  static const Map<Type, String> _shareModelMethodMapper = {
    WeChatShareTextModel: "shareText",
    WeChatShareImageModel: "shareImage",
    WeChatShareMusicModel: "shareMusic",
    WeChatShareVideoModel: "shareVideo",
    WeChatShareWebPageModel: "shareWebPage",
    WeChatShareMiniProgramModel: "shareMiniProgram"
  };

  Stream<WeChatResponse> get response => _responseController.stream;

  ///[appId] is not necessary.
  ///if [doOnIOS] is true ,fluwx will register WXApi on iOS.
  ///if [doOnAndroid] is true, fluwx will register WXApi on Android.
  static Future register(
      {String appId,
      bool doOnIOS: true,
      doOnAndroid: true,
      enableMTA: false}) async {
    return await _channel.invokeMethod("registerApp", {
      "appId": appId,
      "iOS": doOnIOS,
      "android": doOnAndroid,
      "enableMTA": enableMTA
    });
  }

  ///we don't need the response any longer.
  static void dispose() {
    _responseController.close();
  }

//  static Future unregisterApp(RegisterModel model) async {
//    return await _channel.invokeMethod("unregisterApp", model.toMap());
//  }

  ///the [WeChatShareModel] can not be null
  ///see [WeChatShareWebPageModel]
  /// [WeChatShareTextModel]
  ///[WeChatShareVideoModel]
  ///[WeChatShareMusicModel]
  ///[WeChatShareImageModel]
  Future share(WeChatShareModel model) async {
    if (_shareModelMethodMapper.containsKey(model.runtimeType)) {
      return await _channel.invokeMethod(
          _shareModelMethodMapper[model.runtimeType], model.toMap());
    } else {
      return Future.error("no method mapper found[${model.runtimeType}]");
    }
  }

  Future sendAuth(WeChatSendAuthModel model) async {
    return await _channel.invokeMethod("sendAuth", model.toMap());
  }

  Future isWeChatInstalled() async {
    return await _channel.invokeMethod("isWeChatInstalled");
  }

  Future pay(WeChatPayModel model) async {
    return await _channel.invokeMethod("pay", model.toMap());
  }
}
