import 'dart:async';

import 'package:flutter/services.dart';

import 'models/flutter_register_model.dart';
import 'models/wechat_share_models.dart';
import 'models/wechat_send_auth_model.dart';
import 'models/wechat_pay_model.dart';
class Fluwx {
  static const Map<Type, String> _shareModelMethodMapper = {
    WeChatShareTextModel: "shareText",
    WeChatShareImageModel: "shareImage",
    WeChatShareMusicModel: "shareMusic",
    WeChatShareVideoModel: "shareVideo",
    WeChatShareWebPageModel: "shareWebPage",
    WeChatShareMiniProgramModel: "shareMiniProgram"
  };

  static const MethodChannel _channel = const MethodChannel('fluwx');

  StreamController<Map> _responseFromShareController =
      new StreamController.broadcast();

  StreamController<Map> _responseFromAuthController =
  new StreamController.broadcast();

  StreamController<Map> _responseFromPayController =
  new StreamController.broadcast();

  Stream<Map> get responseFromShare => _responseFromShareController.stream;
  Stream<Map> get responseFromAuth => _responseFromAuthController.stream;
  Stream<Map> get responseFromPay => _responseFromPayController.stream;
  ///the [model] should not be null
  static Future registerApp(RegisterModel model) async {
    return await _channel.invokeMethod("registerApp", model.toMap());
  }

//  static Future unregisterApp(RegisterModel model) async {
//    return await _channel.invokeMethod("unregisterApp", model.toMap());
//  }

  void listen() {
    _channel.setMethodCallHandler(_handler);
  }

  void disposeAll() {
    _responseFromShareController.close();
    _responseFromAuthController.close();
    _responseFromPayController.close();
  }

  void disposeResponseFromShare(){
    _responseFromShareController.close();
  }

  void disposeResponseFromAuth(){
    _responseFromAuthController.close();
  }

  void disposeResponseFromPay(){
    _responseFromPayController.close();
  }

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

  Future sendAuth(WeChatSendAuthModel model) async{
    return await _channel.invokeMethod("sendAuth", model.toMap());
  }

  Future isWeChatInstalled() async{
    return await _channel.invokeMethod("isWeChatInstalled");
  }

  Future<dynamic> _handler(MethodCall methodCall) {
    if ("onShareResponse" == methodCall.method) {
      _responseFromShareController.add(methodCall.arguments);
    }else if("onAuthResponse" == methodCall.method){
      _responseFromAuthController.add(methodCall.arguments);
    }else if("onPayResponse" == methodCall.method){
      _responseFromPayController.add(methodCall.arguments);
    }

    return Future.value(true);
  }

  Future pay(WeChatPayModel model) async {
    return await _channel.invokeMethod("pay",model.toMap());
  }
}
