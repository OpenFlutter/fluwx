import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wechat_plugin/src/wechat_share_models.dart';

class WechatPlugin {
  static const MethodChannel _channel =
      const MethodChannel('wechat_plugin');

  static StreamController<Map> _responseStreamController = new StreamController.broadcast();
  static Stream<Map> get weChatResponseUpdate=>_responseStreamController.stream;

  static Future<int>  init(String appId) async{
    return await _channel.invokeMethod("initWeChat");
  }

  static void listen(){
    _channel.setMethodCallHandler(_handler);
  }

  static void dispose(){
    _responseStreamController.close();
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future shareText(WeChatShareTextModel model) async{
    return await _channel.invokeMethod("shareText",model.toMap());
  }

  static Future<dynamic> _handler(MethodCall methodCall){

    if("onWeChatResponse" == methodCall.method){
      _responseStreamController.add(methodCall.arguments);
    }

     return Future.value(true);
  }
}
