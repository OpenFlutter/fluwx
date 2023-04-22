/*
 * Copyright (c) 2023.  OpenFlutter Project
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor
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

import 'method_channel/fluwx_platform_interface.dart';
import 'response/wechat_response.dart';
import 'share/share_models.dart';
import 'wechat_enums.dart';

class Fluwx {
  final List<Function(WeChatResponse response)> _responseListeners = [];

  Fluwx() {
    FluwxPlatform.instance.responseEventHandler.listen((event) {
      for (var listener in _responseListeners) {
        listener(event);
      }
    });
  }

  Future<bool> get isWeChatInstalled =>
      FluwxPlatform.instance.isWeChatInstalled;

  Future<bool> openWeChatApp() async {
    return FluwxPlatform.instance.openWeChatApp();
  }

  Future<bool> registerWxApi({
    required String appId,
    bool doOnIOS = true,
    bool doOnAndroid = true,
    String? universalLink,
  }) async {
    return FluwxPlatform.instance.registerWxApi(
        appId: appId,
        doOnAndroid: doOnAndroid,
        doOnIOS: doOnIOS,
        universalLink: universalLink);
  }

  Future<bool?> startLog({WXLogLevel logLevel = WXLogLevel.unspecific}) {
    return FluwxPlatform.instance.startLog(logLevel: logLevel);
  }

  Future<bool?> stopLog() {
    return FluwxPlatform.instance.stopLog();
  }

  Future<bool> share(WeChatShareModel what) async {
    return FluwxPlatform.instance.share(what);
  }

  Future<bool> sendAuth(
      {required String scope,
      String state = 'state',
      bool nonAutomatic = false}) async {
    return FluwxPlatform.instance
        .sendAuth(scope: scope, nonAutomatic: nonAutomatic);
  }

  Future<bool> subscribeMsg({
    required String appId,
    required int scene,
    required String templateId,
    String? reserved,
  }) async {
    return FluwxPlatform.instance.subscribeMsg(
        appId: appId, scene: scene, templateId: templateId, reserved: reserved);
  }

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
    return FluwxPlatform.instance.autoDeDuct(
        appId: appId,
        mchId: mchId,
        planId: planId,
        contractCode: contractCode,
        requestSerial: requestSerial,
        contractDisplayAccount: contractDisplayAccount,
        notifyUrl: notifyUrl,
        version: version,
        sign: sign,
        timestamp: timestamp,
        returnApp: returnApp,
        businessType: businessType);
  }

  Future<bool> autoDeductV2(
    Map<String, String> queryInfo, {
    int businessType = 12,
  }) async {
    return FluwxPlatform.instance.autoDeductV2(queryInfo, businessType: 12);
  }

  Future<bool> authByQRCode({
    required String appId,
    required String scope,
    required String nonceStr,
    required String timestamp,
    required String signature,
    String? schemeData,
  }) async {
    return FluwxPlatform.instance.authByQRCode(
        appId: appId,
        scope: scope,
        nonceStr: nonceStr,
        timestamp: timestamp,
        signature: signature,
        schemeData: schemeData);
  }

  /// IOS only
  Future<bool> authByPhoneLogin({
    required String scope,
    String state = 'state',
  }) async {
    return FluwxPlatform.instance.authByPhoneLogin(scope: scope, state: state);
  }

  Future<bool> openCustomerServiceChat(
      {required String url, required String corpId}) async {
    return await FluwxPlatform.instance
        .openCustomerServiceChat(url: url, corpId: corpId);
  }

  /// see * https://pay.weixin.qq.com/wiki/doc/apiv3_partner/Offline/apis/chapter6_2_1.shtml
  Future<bool> openBusinessView(
      {required String businessType, required String query}) async {
    return await FluwxPlatform.instance
        .openBusinessView(businessType: businessType, query: query);
  }

  Future<bool> checkSupportOpenBusinessView() async {
    return await FluwxPlatform.instance.checkSupportOpenBusinessView();
  }

  Future<bool> openInvoice(
      {required String appId,
      required String cardType,
      String locationId = "",
      String cardId = "",
      String canMultiSelect = "1"}) async {
    return FluwxPlatform.instance.openInvoice(
        appId: appId,
        cardType: cardType,
        locationId: locationId,
        cardId: cardId,
        canMultiSelect: canMultiSelect);
  }

  Future launchMiniProgram({
    required String username,
    String? path,
    WXMiniProgramType miniProgramType = WXMiniProgramType.release,
  }) async {
    return FluwxPlatform.instance.launchMiniProgram(
        username: username, path: path, miniProgramType: miniProgramType);
  }

  Future<String?> getExtMsg() async {
    return FluwxPlatform.instance.getExtMsg();
  }

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
    return FluwxPlatform.instance.pay(
        appId: appId,
        partnerId: partnerId,
        prepayId: prepayId,
        packageValue: packageValue,
        nonceStr: nonceStr,
        timestamp: timestamp,
        sign: sign,
        signType: signType,
        extData: extData);
  }

  Future<bool> payWithHongKongWallet({required String prepayId}) async {
    return FluwxPlatform.instance.payWithHongKongWallet(prepayId: prepayId);
  }

  subscribeResponse(Function(WeChatResponse response) listener) {
    _responseListeners.add(listener);
  }

  unsubscribeResponse(Function(WeChatResponse response) listener) {
    _responseListeners.remove(listener);
  }
}
