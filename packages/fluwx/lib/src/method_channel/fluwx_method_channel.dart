/*
 * Copyright (c) 2023.  OpenFlutter Project
 *
 *   Licensed to the Apache Software Foundation (ASF) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  The ASF licenses this
 * file to you under the Apache License, Version 2.0 (the 'License'); you may not
 * use this file except in compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../foundation/arguments.dart';
import '../response/wechat_response.dart';
import 'fluwx_platform_interface.dart';

/// An implementation of [FluwxPlatform] that uses method channels.
class MethodChannelFluwx extends FluwxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.jarvanmo/fluwx');

  MethodChannelFluwx() {
    methodChannel.setMethodCallHandler(_methodHandler);
  }

  final Map<Type, String> _shareModelMethodMapper = {
    WeChatShareTextModel: 'shareText',
    WeChatShareImageModel: 'shareImage',
    WeChatShareMusicModel: 'shareMusic',
    WeChatShareVideoModel: 'shareVideo',
    WeChatShareWebPageModel: 'shareWebPage',
    WeChatShareMiniProgramModel: 'shareMiniProgram',
    WeChatShareFileModel: 'shareFile',
    WeChatShareEmojiModel: 'shareEmoji',
  };

  final StreamController<WeChatResponse> _responseEventHandler =
      StreamController.broadcast();

  /// Response answers from WeChat after sharing, payment etc.
  @override
  Stream<WeChatResponse> get responseEventHandler =>
      _responseEventHandler.stream;

  Future _methodHandler(MethodCall methodCall) {
    if (methodCall.method == "wechatLog") {
      _printLog(methodCall.arguments);
    } else {
      final response = WeChatResponse.create(
        methodCall.method,
        methodCall.arguments,
      );
      _responseEventHandler.add(response);
    }

    return Future.value();
  }

  _printLog(Map data) {
    debugPrint("FluwxLog: ${data["detail"]}");
  }

  /// [true] if WeChat installed, otherwise [false].
  /// Please add WeChat to the white list in order use this method on IOS.
  @override
  Future<bool> get isWeChatInstalled async {
    return await methodChannel.invokeMethod('isWeChatInstalled');
  }

  /// The OpenType has various types, which are:
  /// WeChatApp
  /// Browser
  /// RankList
  /// BusinessView
  /// Invoice
  /// CustomerServiceChat
  /// MiniProgram
  /// SubscribeMessage
  /// How to use:
  ///  Fluwx().open(
  ///  target: CustomerServiceChat(
  ///    url: 'URL',
  ///    corpId: 'ID',
  ///    ),
  /// );
  @override
  Future<bool> open(OpenType target) async {
    switch (target) {
      case WeChatApp():
        return await methodChannel.invokeMethod(
                'openWXApp', target.arguments) ??
            false;
      case Browser():
        return await methodChannel.invokeMethod('openUrl', target.arguments) ??
            false;
      case RankList():
        return await methodChannel.invokeMethod("openRankList") ?? false;
      case BusinessView():
        return await methodChannel.invokeMethod(
                "openBusinessView", target.arguments) ??
            false;
      case Invoice():
        return await methodChannel.invokeMethod(
                "openWeChatInvoice", target.arguments) ??
            false;
      case CustomerServiceChat():
        return await methodChannel.invokeMethod(
                "openWeChatCustomerServiceChat", target.arguments) ??
            false;
      case MiniProgram():
        return await methodChannel.invokeMethod(
                'launchMiniProgram', target.arguments) ??
            false;
      case SubscribeMessage():
        return await methodChannel.invokeMethod(
            'subscribeMsg', target.arguments);
    }
  }

  @override
  Future<bool> registerApi({
    required String appId,
    bool doOnIOS = true,
    bool doOnAndroid = true,
    String? universalLink,
  }) async {
    if (doOnIOS && Platform.isIOS) {
      if (universalLink == null ||
          universalLink.trim().isEmpty ||
          !universalLink.startsWith('https')) {
        throw ArgumentError.value(
          universalLink,
          "You're trying to use illegal universal link, see "
          'https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html '
          'for more detail',
        );
      }
    }
    return await methodChannel.invokeMethod('registerApp', {
      'appId': appId,
      'iOS': doOnIOS,
      'android': doOnAndroid,
      'universalLink': universalLink
    });
  }

  /// Get ext Message
  @override
  Future<String?> getExtMsg() {
    return methodChannel.invokeMethod('getExtMsg');
  }

  /// see [_shareModelMethodMapper] for detail.
  @override
  Future<bool> share(WeChatShareModel what) async {
    if (_shareModelMethodMapper.containsKey(what.runtimeType)) {
      final channelName = _shareModelMethodMapper[what.runtimeType];

      if (channelName == null) {
        throw ArgumentError.value(
          '${what.runtimeType} method channel not found',
        );
      }
      return await methodChannel.invokeMethod(channelName, what.arguments);
    }
    return Future.error('no method mapper found[${what.runtimeType}]');
  }

  @override
  Future<bool> authBy(AuthType which) async {
    switch (which) {
      case NormalAuth():
        return await methodChannel.invokeMethod(
          'sendAuth',
          which.arguments,
        );
      case QRCode():
        return await methodChannel.invokeMethod(
                'authByQRCode', which.arguments) ??
            false;
      case PhoneLogin():
        return await methodChannel.invokeMethod(
            'authByPhoneLogin', which.arguments);
    }
  }

  @override
  Future<bool> pay(PayType which) async {
    switch (which) {
      case Payment():
        return await methodChannel.invokeMethod(
            'payWithFluwx', which.arguments);
      case HongKongWallet():
        return await methodChannel.invokeMethod(
            'payWithHongKongWallet', which.arguments);
    }
  }

  @override
  Future<bool> autoDeduct(AutoDeduct data) async {
    return await methodChannel.invokeMethod(
            data.isV2 ? "autoDeductV2" : 'autoDeduct', data.arguments) ??
        false;
  }

  /// stop [authWeChatByQRCode]
  @override
  Future<bool> stopAuthByQRCode() async {
    return await methodChannel.invokeMethod('stopAuthByQRCode');
  }

  ///Only works on iOS in debug mode.
  @override
  Future<void> selfCheck() async {
    return await methodChannel.invokeMethod('selfCheck');
  }

  @override
  Future<void> attemptToResumeMsgFromWx() async {
    return await methodChannel.invokeMethod("attemptToResumeMsgFromWx");
  }

  @override
  Future<bool> get isSupportOpenBusinessView async =>
      await methodChannel.invokeMethod("checkSupportOpenBusinessView");
}
