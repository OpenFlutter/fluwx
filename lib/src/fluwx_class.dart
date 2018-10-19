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

import 'models/wechat_response.dart';
import 'models/wechat_send_auth_model.dart';
import 'models/wechat_share_models.dart';
import 'models/wechat_launchminiprogram_model.dart';
import 'package:flutter/foundation.dart';

StreamController<WeChatShareResponse> _responseShareController =
    new StreamController.broadcast();

Stream<WeChatShareResponse> get responseFromShare =>
    _responseShareController.stream;

StreamController<WeChatAuthResponse> _responseAuthController =
    new StreamController.broadcast();

Stream<WeChatAuthResponse> get responseFromAuth =>
    _responseAuthController.stream;

StreamController<WeChatPaymentResponse> _responsePaymentController =
    new StreamController.broadcast();

Stream<WeChatPaymentResponse> get responseFromPayment =>
    _responsePaymentController.stream;

StreamController<WeChatLaunchMiniProgramResponse> _responseLaunchMiniProgramController =
    new StreamController.broadcast();

final MethodChannel _channel = const MethodChannel('com.jarvanmo/fluwx')
  ..setMethodCallHandler(_handler);

Future<dynamic> _handler(MethodCall methodCall) {
  if ("onShareResponse" == methodCall.method) {
    _responseShareController
        .add(WeChatShareResponse.fromMap(methodCall.arguments));
  } else if ("onAuthResponse" == methodCall.method) {
    _responseAuthController
        .add(WeChatAuthResponse.fromMap(methodCall.arguments));
  } else if ("onLaunchMiniProgramResponse" == methodCall.method) {
    _responseLaunchMiniProgramController
        .add(WeChatLaunchMiniProgramResponse.fromMap(methodCall.arguments));
  } else if ("onPayResponse" == methodCall.method) {
    _responsePaymentController
        .add(WeChatPaymentResponse.fromMap(methodCall.arguments));
  }

  return Future.value(true);
}

const Map<Type, String> _shareModelMethodMapper = {
  WeChatShareTextModel: "shareText",
  WeChatShareImageModel: "shareImage",
  WeChatShareMusicModel: "shareMusic",
  WeChatShareVideoModel: "shareVideo",
  WeChatShareWebPageModel: "shareWebPage",
  WeChatShareMiniProgramModel: "shareMiniProgram"
};

///[appId] is not necessary.
///if [doOnIOS] is true ,fluwx will register WXApi on iOS.
///if [doOnAndroid] is true, fluwx will register WXApi on Android.
Future register(
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

///we don't need the response any longer if params are true.
void dispose({shareResponse: true, authResponse: true, paymentResponse: true,launchMiniProgramResponse:true}) {
  if (shareResponse) {
    _responseShareController.close();
  }

  if (authResponse) {
    _responseAuthController.close();
  }
  if (launchMiniProgramResponse) {
    _responseLaunchMiniProgramController.close();
  }

  if (paymentResponse) {
    _responseAuthController.close();
  }
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

Future launchMiniProgram(WeChatLaunchMiniProgramModel model) async {
  return await _channel.invokeMethod("launchMiniProgram", model.toMap());
}


Future isWeChatInstalled() async {
  return await _channel.invokeMethod("isWeChatInstalled");
}

Future pay(
    {@required String appId,
    @required String partnerId,
    @required String prepayId,
    @required String packageValue,
    @required String nonceStr,
    @required int timeStamp,
    @required String sign,
    String signType,
    String extData}) async {
  return await _channel.invokeMethod("payWithFluwx", {
    "appId": appId,
    "partnerId": partnerId,
    "prepayId": prepayId,
    "packageValue": packageValue,
    "nonceStr": nonceStr,
    "timeStamp": timeStamp,
    "sign": sign,
    "signType": signType,
    "extData": extData,
  });
}
