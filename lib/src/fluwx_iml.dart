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

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/wechat_response.dart';

StreamController<WeChatPaymentResponse> _responsePaymentController =
    new StreamController.broadcast();

///Response from payment
Stream<WeChatPaymentResponse> get responseFromPayment =>
    _responsePaymentController.stream;

final MethodChannel _channel =
    const MethodChannel('com.jarvanmo/fluwx_pay_only')
      ..setMethodCallHandler(_handler);

Future<dynamic> _handler(MethodCall methodCall) {
  if ("onPayResponse" == methodCall.method) {
    _responsePaymentController
        .add(WeChatPaymentResponse.fromMap(methodCall.arguments));
  }

  return Future.value(true);
}

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
void dispose() {
  _responsePaymentController.close();
}

/// true if WeChat is installed,otherwise false.
/// However,the following key-value must be added into your info.plist since iOS 9:
/// <key>LSApplicationQueriesSchemes</key>
///<array>
///<string>weixin</string>
///</array>
///<key>NSAppTransportSecurity</key>
///<dict>
///<key>NSAllowsArbitraryLoads</key>
///<true/>
///</dict>
///
Future isWeChatInstalled() async {
  return await _channel.invokeMethod("isWeChatInstalled");
}

/// params are from server
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

Future<bool> openWeChatApp() async {
  return await _channel.invokeMethod("openWXApp");
}
