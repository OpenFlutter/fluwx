import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wechat_plugin/src/wechat_share_models.dart';

class WechatPlugin {


  static const  MethodChannel _channel = const MethodChannel('wechat_plugin');

   StreamController<Map> _responseStreamController = new StreamController.broadcast();
   Stream<Map> get weChatResponseUpdate=>_responseStreamController.stream;

   static Future<int>  init(String appId) async{
    return await _channel.invokeMethod("initWeChat");
  }

   void listen(){
    _channel.setMethodCallHandler(_handler);
  }

   void dispose(){
    _responseStreamController.close();
  }



   Future shareText(WeChatShareTextModel model) async{
     await _channel.invokeMethod("shareText",model.toMap());
  }

   Future shareMiniProgram(WeChatShareMiniProgramModel model)async{
    return await _channel.invokeMethod("shareMiniProgram",model.toMap());
  }


   Future shareMusic(WeChatShareMusicModel model)async{
    return await _channel.invokeMethod("shareMusic",model.toMap());
  }

  Future shareVideo(WeChatShareVideoModel model)async{
    return await _channel.invokeMethod("shareVideo",model.toMap());
  }

  Future shareWebPage(WeChatShareWebPageModel model)async{
    return await _channel.invokeMethod("shareWebPage",model.toMap());
  }



   Future<dynamic> _handler(MethodCall methodCall){

    if("onWeChatResponse" == methodCall.method){
      _responseStreamController.add(methodCall.arguments);
    }

     return Future.value(true);
  }
}
