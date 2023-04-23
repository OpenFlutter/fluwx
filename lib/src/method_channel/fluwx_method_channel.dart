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

import '../open_command.dart';
import '../response/wechat_response.dart';
import '../share/share_models.dart';
import '../wechat_enums.dart';
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

  @override
  Future<bool> open(OpenCommand what) async {
    switch (what) {
      case OpenWeChat():
        return await methodChannel.invokeMethod('openWXApp');
      case OpenUrl():
        return await methodChannel.invokeMethod(
          'openUrl',
          <String, dynamic>{
            'url': what.url,
          },
        );
      case OpenRankList():
        return await methodChannel.invokeMethod("openRankList");
    }
  }

  /// It's ok if you register multi times.
  /// [appId] is not necessary.
  /// if [doOnIOS] is true ,fluwx will register WXApi on iOS.
  /// if [doOnAndroid] is true, fluwx will register WXApi on Android.
  /// [universalLink] is required if you want to register on iOS.
  @override
  Future<bool> registerWxApi({
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

  /// Share your requests to WeChat.
  /// This depends on the actual type of [what].
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
      return await methodChannel.invokeMethod(channelName, what.toMap());
    }
    return Future.error('no method mapper found[${what.runtimeType}]');
  }

  /// The WeChat-Login is under Auth-2.0
  /// This method login with native WeChat app.
  /// For users without WeChat app, please use [authByQRCode] instead
  /// This method only supports getting AuthCode,this is first step to login with WeChat
  /// Once AuthCode got, you need to request Access_Token
  /// For more information please visit：
  /// * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=
  @override
  Future<bool> sendAuth(
      {required String scope,
      String state = 'state',
      bool nonAutomatic = false}) async {
    assert(scope.trim().isNotEmpty);
    return await methodChannel.invokeMethod(
      'sendAuth',
      {'scope': scope, 'state': state, 'nonAutomatic': nonAutomatic},
    );
  }

  /// open mini-program
  /// see [WXMiniProgramType]
  @override
  Future<bool> launchMiniProgram({
    required String username,
    String? path,
    WXMiniProgramType miniProgramType = WXMiniProgramType.release,
  }) async {
    assert(username.trim().isNotEmpty);
    return await methodChannel.invokeMethod('launchMiniProgram', {
      'userName': username,
      'path': path,
      'miniProgramType': miniProgramType.value
    });
  }

  /// request payment with WeChat.
  /// Read the official document for more detail.
  /// [timestamp] is int because [timestamp] will be mapped to Unit32.
  @override
  Future<bool> pay({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String packageValue,
    required String nonceStr,
    required int timestamp,
    required String sign,
    String? signType,
    String? extData,
  }) async {
    return await methodChannel.invokeMethod('payWithFluwx', {
      'appId': appId,
      'partnerId': partnerId,
      'prepayId': prepayId,
      'packageValue': packageValue,
      'nonceStr': nonceStr,
      'timeStamp': timestamp,
      'sign': sign,
      'signType': signType,
      'extData': extData,
    });
  }

  /// request Hong Kong Wallet payment with WeChat.
  /// Read the official document for more detail.
  @override
  Future<bool> payWithHongKongWallet({required String prepayId}) async {
    return await methodChannel.invokeMethod('payWithHongKongWallet', {
      'prepayId': prepayId,
    });
  }

  /// subscribe WeChat message
  @override
  Future<bool> subscribeMsg({
    required String appId,
    required int scene,
    required String templateId,
    String? reserved,
  }) async {
    return await methodChannel.invokeMethod(
      'subscribeMsg',
      {
        'appId': appId,
        'scene': scene,
        'templateId': templateId,
        'reserved': reserved,
      },
    );
  }

  /// please read official docs.
  @override
  Future<bool> autoDeDuct({
    required String appId,
    required String mchId,
    required String planId,
    required String contractCode,
    required String requestSerial,
    required String contractDisplayAccount,
    required String notifyUrl,
    required String version,
    required String sign,
    required String timestamp,
    String returnApp = '3',
    int businessType = 12,
  }) async {
    return await methodChannel.invokeMethod('autoDeduct', {
          'appid': appId,
          'mch_id': mchId,
          'plan_id': planId,
          'contract_code': contractCode,
          'request_serial': requestSerial,
          'contract_display_account': contractDisplayAccount,
          'notify_url': notifyUrl,
          'version': version,
          'sign': sign,
          'timestamp': timestamp,
          'return_app': returnApp,
          'businessType': businessType
        }) ??
        false;
  }

  /// please read * [official docs](https://pay.weixin.qq.com/wiki/doc/api/wxpay_v2/papay/chapter3_2.shtml).

  @override
  Future<bool> autoDeductV2(
    Map<String, String> queryInfo, {
    int businessType = 12,
  }) async {
    return await methodChannel.invokeMethod('autoDeductV2',
            {'queryInfo': queryInfo, 'businessType': businessType}) ??
        false;
  }

  /// Sometimes WeChat  is not installed on users's devices.However we can
  /// request a QRCode so that we can get AuthCode by scanning the QRCode
  /// All required params must not be null or empty
  /// [schemeData] only works on iOS
  /// see * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=215238808828h4XN&token=&lang=zh_CN
  @override
  Future<bool> authByQRCode({
    required String appId,
    required String scope,
    required String nonceStr,
    required String timestamp,
    required String signature,
    String? schemeData,
  }) async {
    assert(appId.isNotEmpty);
    assert(scope.isNotEmpty);
    assert(nonceStr.isNotEmpty);
    assert(timestamp.isNotEmpty);
    assert(signature.isNotEmpty);

    return await methodChannel.invokeMethod('authByQRCode', {
      'appId': appId,
      'scope': scope,
      'nonceStr': nonceStr,
      'timeStamp': timestamp,
      'signature': signature,
      'schemeData': schemeData
    });
  }

  /// stop [authWeChatByQRCode]
  @override
  Future<bool> stopWeChatAuthByQRCode() async {
    return await methodChannel.invokeMethod('stopAuthByQRCode');
  }

  /// IOS only
  @override
  Future<bool> authByPhoneLogin({
    required String scope,
    String state = 'state',
  }) async {
    return await methodChannel.invokeMethod(
      'authByPhoneLogin',
      {'scope': scope, 'state': state},
    );
  }

  @override
  Future<bool> openCustomerServiceChat(
      {required String url, required String corpId}) async {
    return await methodChannel.invokeMethod(
        "openWeChatCustomerServiceChat", {"corpId": corpId, "url": url});
  }

  /// see * https://pay.weixin.qq.com/wiki/doc/apiv3_partner/Offline/apis/chapter6_2_1.shtml
  @override
  Future<bool> openBusinessView(
      {required String businessType, required String query}) async {
    return await methodChannel.invokeMethod(
        "openBusinessView", {"businessType": businessType, "query": query});
  }

  @override
  Future<bool> checkSupportOpenBusinessView() async {
    return await methodChannel.invokeMethod("checkSupportOpenBusinessView");
  }

  @override
  Future<bool> openInvoice(
      {required String appId,
      required String cardType,
      String locationId = "",
      String cardId = "",
      String canMultiSelect = "1"}) async {
    return await methodChannel.invokeMethod("openWeChatInvoice", {
      "appId": appId,
      "cardType": cardType,
      "locationId": locationId,
      "cardId": cardId,
      "canMultiSelect": canMultiSelect
    });
  }
}
