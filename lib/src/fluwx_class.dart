import 'dart:async';

import 'package:flutter/services.dart';

import 'models/flutter_register_model.dart';
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

  ///the [model] should not be null
  static Future registerApp(RegisterModel model) async {
    return await _channel.invokeMethod("registerApp", model.toMap());
  }

  ///we don't need the response any longer.
  static void dispose() {
    _responseController.close();
  }

//  static Future unregisterApp(RegisterModel model) async {
//    return await _channel.invokeMethod("unregisterApp", model.toMap());
//  }

  ///the [model] can not be null
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
