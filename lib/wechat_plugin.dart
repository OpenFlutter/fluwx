import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wechat_plugin/src/wechat_share_models.dart';

class WechatPlugin {
  static const MethodChannel _channel =
      const MethodChannel('wechat_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future shareText(WeChatShareTextModel model) async{
    return await _channel.invokeMethod("shareText",model.toMap());
  }
}
