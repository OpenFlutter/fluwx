/*
 * Copyright (c) 2020.  OpenFlutter Project
 *
 *   Licensed to the Apache Software Foundation (ASF) under one or more contributor
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

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluwx_no_pay/src/wechat_enums.dart';

import 'response/wechat_response.dart';
import 'share/share_models.dart';

const Map<Type, String> _shareModelMethodMapper = {
  WeChatShareTextModel: 'shareText',
  WeChatShareImageModel: 'shareImage',
  WeChatShareMusicModel: 'shareMusic',
  WeChatShareVideoModel: 'shareVideo',
  WeChatShareWebPageModel: 'shareWebPage',
  WeChatShareMiniProgramModel: 'shareMiniProgram',
  WeChatShareFileModel: 'shareFile',
};

MethodChannel _channel = MethodChannel('com.jarvanmo/fluwx')
  ..setMethodCallHandler(_methodHandler);

StreamController<BaseWeChatResponse> _weChatResponseEventHandlerController =
    StreamController.broadcast();

/// Response answers from WeChat after sharing, payment etc.
Stream<BaseWeChatResponse> get weChatResponseEventHandler =>
    _weChatResponseEventHandlerController.stream;

/// [true] if WeChat installed, otherwise [false].
/// Please add WeChat to the white list in order use this method on IOS.
Future<bool> get isWeChatInstalled async {
  return await _channel.invokeMethod('isWeChatInstalled');
}

///just open WeChat, noting to do.
Future<bool> openWeChatApp() async {
  return await _channel.invokeMethod('openWXApp');
}

/// It's ok if you register multi times.
/// [appId] is not necessary.
/// if [doOnIOS] is true ,fluwx will register WXApi on iOS.
/// if [doOnAndroid] is true, fluwx will register WXApi on Android.
/// [universalLink] is required if you want to register on iOS.
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
  return await _channel.invokeMethod('registerApp', {
    'appId': appId,
    'iOS': doOnIOS,
    'android': doOnAndroid,
    'universalLink': universalLink
  });
}

// Get ext Message
Future<String?> getExtMsg() {
  return _channel.invokeMethod('getExtMsg');
}

/// start Log
/// defalult [WXLogLevel.DETAIL]
Future<bool?> startLog({WXLogLevel logLevel = WXLogLevel.DETAIL}) async {
  return await _channel
      .invokeMethod('startLog', {'logLevel': logLevel.toNativeInt()});
}

/// stop log
Future<bool?> stopLog() async {
  return await _channel.invokeMethod('stopLog');
}

/// Share your requests to WeChat.
/// This depends on the actual type of [model].
/// see [_shareModelMethodMapper] for detail.
Future<bool> shareToWeChat(WeChatShareBaseModel model) async {
  if (_shareModelMethodMapper.containsKey(model.runtimeType)) {
    final methodChannel = _shareModelMethodMapper[model.runtimeType];
    if (methodChannel == null) {
      throw ArgumentError.value(
        '${model.runtimeType} method channel not found',
      );
    }
    return await _channel.invokeMethod(methodChannel, model.toMap());
  }
  return Future.error('no method mapper found[${model.runtimeType}]');
}

/// The WeChat-Login is under Auth-2.0
/// This method login with native WeChat app.
/// For users without WeChat app, please use [authByQRCode] instead
/// This method only supports getting AuthCode,this is first step to login with WeChat
/// Once AuthCode got, you need to request Access_Token
/// For more information please visit：
/// * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=
Future<bool> sendWeChatAuth(
    {required String scope,
    String state = 'state',
    bool nonAutomatic = false}) async {
  assert(scope.trim().isNotEmpty);
  return await _channel.invokeMethod(
    'sendAuth',
    {'scope': scope, 'state': state, 'nonAutomatic': nonAutomatic},
  );
}

/// open mini-program
/// see [WXMiniProgramType]
Future<bool> launchWeChatMiniProgram({
  required String username,
  String? path,
  WXMiniProgramType miniProgramType = WXMiniProgramType.RELEASE,
}) async {
  assert(username.trim().isNotEmpty);
  return await _channel.invokeMethod('launchMiniProgram', {
    'userName': username,
    'path': path,
    'miniProgramType': miniProgramType.toNativeInt()
  });
}

/// request payment with WeChat.
/// Read the official document for more detail.
/// [timeStamp] is int because [timeStamp] will be mapped to Unit32.
Future<bool> payWithWeChat({
  required String appId,
  required String partnerId,
  required String prepayId,
  required String packageValue,
  required String nonceStr,
  required int timeStamp,
  required String sign,
  String? signType,
  String? extData,
}) async {
  return await _channel.invokeMethod('payWithFluwx', {
    'appId': appId,
    'partnerId': partnerId,
    'prepayId': prepayId,
    'packageValue': packageValue,
    'nonceStr': nonceStr,
    'timeStamp': timeStamp,
    'sign': sign,
    'signType': signType,
    'extData': extData,
  });
}

/// request Hong Kong Wallet payment with WeChat.
/// Read the official document for more detail.
Future<bool> payWithWeChatHongKongWallet({required String prepayId}) async {
  return await _channel.invokeMethod('payWithHongKongWallet', {
    'prepayId': prepayId,
  });
}

/// subscribe WeChat message
Future<bool> subscribeWeChatMsg({
  required String appId,
  required int scene,
  required String templateId,
  String? reserved,
}) async {
  return await _channel.invokeMethod(
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
Future<bool> autoDeDuctWeChat({
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
  return await _channel.invokeMethod('autoDeduct', {
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
  });
}

/// please read * [official docs](https://pay.weixin.qq.com/wiki/doc/api/wxpay_v2/papay/chapter3_2.shtml).
Future<bool> autoDeductWeChatV2(
  Map<String, String> queryInfo, {
  int businessType = 12,
}) async {
  return await _channel.invokeMethod(
      'autoDeductV2', {'queryInfo': queryInfo, 'businessType': businessType});
}

/// Sometimes WeChat  is not installed on users's devices.However we can
/// request a QRCode so that we can get AuthCode by scanning the QRCode
/// All required params must not be null or empty
/// [schemeData] only works on iOS
/// see * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=215238808828h4XN&token=&lang=zh_CN
Future<bool> authWeChatByQRCode({
  required String appId,
  required String scope,
  required String nonceStr,
  required String timeStamp,
  required String signature,
  String? schemeData,
}) async {
  assert(appId.isNotEmpty);
  assert(scope.isNotEmpty);
  assert(nonceStr.isNotEmpty);
  assert(timeStamp.isNotEmpty);
  assert(signature.isNotEmpty);

  return await _channel.invokeMethod('authByQRCode', {
    'appId': appId,
    'scope': scope,
    'nonceStr': nonceStr,
    'timeStamp': timeStamp,
    'signature': signature,
    'schemeData': schemeData
  });
}

/// stop [authWeChatByQRCode]
Future<bool> stopWeChatAuthByQRCode() async {
  return await _channel.invokeMethod('stopAuthByQRCode');
}

Future _methodHandler(MethodCall methodCall) {
  final response = BaseWeChatResponse.create(
    methodCall.method,
    methodCall.arguments,
  );
  _weChatResponseEventHandlerController.add(response);
  return Future.value();
}

/// IOS only
Future<bool> authWeChatByPhoneLogin({
  required String scope,
  String state = 'state',
}) async {
  return await _channel.invokeMethod(
    'authByPhoneLogin',
    {'scope': scope, 'state': state},
  );
}

Future<bool> openWeChatCustomerServiceChat(
    {required String url, required String corpId}) async {
  return await _channel.invokeMethod(
      "openWeChatCustomerServiceChat", {"corpId": corpId, "url": url});
}

/// see * https://pay.weixin.qq.com/wiki/doc/apiv3_partner/Offline/apis/chapter6_2_1.shtml
Future<bool> openWeChatBusinessView(
    {required String businessType, required String query}) async {
  return await _channel.invokeMethod(
      "openBusinessView", {"businessType": businessType, "query": query});
}

Future<bool> checkSupportOpenBusinessView() async {
  return await _channel.invokeMethod("checkSupportOpenBusinessView");
}

Future<bool> openWeChatInvoice(
    {required String appId,
    required String cardType,
    String locationId = "",
    String cardId = "",
    String canMultiSelect = "1"}) async {
  return await _channel.invokeMethod("openWeChatInvoice", {
    "appId": appId,
    "cardType": cardType,
    "locationId": locationId,
    "cardId": cardId,
    "canMultiSelect": canMultiSelect
  });
}
