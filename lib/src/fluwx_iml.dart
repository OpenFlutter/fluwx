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
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/wechat_auth_by_qr_code.dart';
import 'models/wechat_response.dart';
import 'models/wechat_share_models.dart';
import 'utils/utils.dart';
import 'wechat_type.dart';

StreamController<WeChatShareResponse> _responseShareController =
    new StreamController.broadcast();

/// Response from share
Stream<WeChatShareResponse> get responseFromShare =>
    _responseShareController.stream;

StreamController<WeChatAuthResponse> _responseAuthController =
    new StreamController.broadcast();

/// Response from auth
Stream<WeChatAuthResponse> get responseFromAuth =>
    _responseAuthController.stream;

StreamController<WeChatPaymentResponse> _responsePaymentController =
    new StreamController.broadcast();

///Response from payment
Stream<WeChatPaymentResponse> get responseFromPayment =>
    _responsePaymentController.stream;

Stream<WeChatLaunchMiniProgramResponse> get responseFromLaunchMiniProgram =>
    _responseLaunchMiniProgramController.stream;

///Response from launching mini-program
StreamController<WeChatLaunchMiniProgramResponse>
    _responseLaunchMiniProgramController = new StreamController.broadcast();

StreamController<WeChatSubscribeMsgResp> _responseFromSubscribeMsg =
    new StreamController.broadcast();

///Response from subscribing micro-message
Stream<WeChatSubscribeMsgResp> get responseFromSubscribeMsg =>
    _responseFromSubscribeMsg.stream;

StreamController<AuthByQRCodeResult> _authByQRCodeFinishedController =
    new StreamController.broadcast();

///invoked when [authByQRCode] finished
Stream<AuthByQRCodeResult> get onAuthByQRCodeFinished =>
    _authByQRCodeFinishedController.stream;

StreamController<Uint8List> _onAuthGotQRCodeController =
    new StreamController.broadcast();

///when QRCode received
Stream<Uint8List> get onAuthGotQRCode => _onAuthGotQRCodeController.stream;

StreamController _onQRCodeScannedController = new StreamController();

///after uer scanned the QRCode you just received
Stream get onQRCodeScanned => _onQRCodeScannedController.stream;

StreamController<WeChatAutoDeductResponse> _responseAutoDeductController =
    new StreamController.broadcast();

/// Response from AutoDeduct
Stream<WeChatAutoDeductResponse> get responseFromAutoDeduct =>
    _responseAutoDeductController.stream;

final MethodChannel _channel = const MethodChannel('com.jarvanmo/fluwx')
  ..setMethodCallHandler(_handler);

Future<dynamic> _handler(MethodCall methodCall) {
  if ("onShareResponse" == methodCall.method) {
    _responseShareController.sink
        .add(WeChatShareResponse.fromMap(methodCall.arguments));
  } else if ("onAuthResponse" == methodCall.method) {
    _responseAuthController.sink
        .add(WeChatAuthResponse.fromMap(methodCall.arguments));
  } else if ("onLaunchMiniProgramResponse" == methodCall.method) {
    _responseLaunchMiniProgramController.sink
        .add(WeChatLaunchMiniProgramResponse.fromMap(methodCall.arguments));
  } else if ("onPayResponse" == methodCall.method) {
    _responsePaymentController.sink
        .add(WeChatPaymentResponse.fromMap(methodCall.arguments));
  } else if ("onSubscribeMsgResp" == methodCall.method) {
    _responseFromSubscribeMsg.sink
        .add(WeChatSubscribeMsgResp.fromMap(methodCall.arguments));
  } else if ("onAuthByQRCodeFinished" == methodCall.method) {
    _handleOnAuthByQRCodeFinished(methodCall);
  } else if ("onAuthGotQRCode" == methodCall.method) {
    _onAuthGotQRCodeController.sink.add(methodCall.arguments);
  } else if ("onQRCodeScanned" == methodCall.method) {
    _onQRCodeScannedController.sink.add(null);
  } else if ("onAutoDeductResponse" == methodCall.method) {
    _responseAutoDeductController.sink
        .add(WeChatAutoDeductResponse.fromMap(methodCall.arguments));
  }

  return Future.value(true);
}

///[appId] is not necessary.
///if [doOnIOS] is true ,fluwx will register WXApi on iOS.
///if [doOnAndroid] is true, fluwx will register WXApi on Android.
/// [universalLink] is required if you want to register on iOS.
@Deprecated("repleace with registerWxApi")
Future register(
    {String appId,
    bool doOnIOS: true,
    bool doOnAndroid: true,
    String universalLink}) async {
  return await _channel.invokeMethod("registerApp", {
    "appId": appId,
    "iOS": doOnIOS,
    "android": doOnAndroid,
    "universalLink": universalLink
  });
}

///[appId] is not necessary.
///if [doOnIOS] is true ,fluwx will register WXApi on iOS.
///if [doOnAndroid] is true, fluwx will register WXApi on Android.
/// [universalLink] is required if you want to register on iOS.
Future registerWxApi(
    {String appId,
    bool doOnIOS: true,
    bool doOnAndroid: true,
    String universalLink}) async {
  if (doOnIOS && Platform.isIOS) {
    if (universalLink.trim().isEmpty || !universalLink.startsWith("https")) {
      throw ArgumentError.value(universalLink,
          "your universal link is illegal, see https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html for detail");
    }
  }

  return await _channel.invokeMethod("registerApp", {
    "appId": appId,
    "iOS": doOnIOS,
    "android": doOnAndroid,
    "universalLink": universalLink
  });
}

///we don't need the response any longer if params are true.
@Deprecated("use closeFluwxStreams instead")
void dispose({
  shareResponse: true,
  authResponse: true,
  paymentResponse: true,
  launchMiniProgramResponse: true,
  onAuthByQRCodeFinished: true,
  onAuthGotQRCode: true,
  onQRCodeScanned: true,
}) {
  if (shareResponse) {
    _responseShareController.close();
  }

  if (authResponse) {
    _responseAuthController.close();
  }
  if (launchMiniProgramResponse) {
    _responseLaunchMiniProgramController.close();
  }

  if (paymentResponse) {
    _responsePaymentController.close();
  }

  if (onAuthByQRCodeFinished) {
    _authByQRCodeFinishedController.close();
  }

  if (onAuthGotQRCode) {
    _onAuthGotQRCodeController.close();
  }

  if (onQRCodeScanned) {
    _onQRCodeScannedController.close();
  }
}

///we don't need the response any longer if params are true.
void closeFluwxStreams({
  shareResponse: true,
  authResponse: true,
  paymentResponse: true,
  launchMiniProgramResponse: true,
  onAuthByQRCodeFinished: true,
  onAuthGotQRCode: true,
  onQRCodeScanned: true,
}) {
  if (shareResponse) {
    _responseShareController.close();
  }

  if (authResponse) {
    _responseAuthController.close();
  }
  if (launchMiniProgramResponse) {
    _responseLaunchMiniProgramController.close();
  }

  if (paymentResponse) {
    _responsePaymentController.close();
  }

  if (onAuthByQRCodeFinished) {
    _authByQRCodeFinishedController.close();
  }

  if (onAuthGotQRCode) {
    _onAuthGotQRCodeController.close();
  }

  if (onQRCodeScanned) {
    _onQRCodeScannedController.close();
  }
}

//  static Future unregisterApp(RegisterModel model) async {
//    return await _channel.invokeMethod("unregisterApp", model.toMap());
//  }

///the [WeChatShareModel] can not be null
///see [WeChatShareWebPageModel]
/// [WeChatShareTextModel]
///[WeChatShareVideoModel]
///[WeChatShareMusicModel]
///[WeChatShareImageModel]
@Deprecated("use shareToWeChat instead")
Future share(WeChatShareModel model) async {
  if (_shareModelMethodMapper.containsKey(model.runtimeType)) {
    return await _channel.invokeMethod(
        _shareModelMethodMapper[model.runtimeType], model.toMap());
  } else {
    return Future.error("no method mapper found[${model.runtimeType}]");
  }
}

///the [WeChatShareModel] can not be null
///see [WeChatShareWebPageModel]
/// [WeChatShareTextModel]
///[WeChatShareVideoModel]
///[WeChatShareMusicModel]
///[WeChatShareImageModel]
Future shareToWeChat(WeChatShareModel model) async {
  if (_shareModelMethodMapper.containsKey(model.runtimeType)) {
    return await _channel.invokeMethod(
        _shareModelMethodMapper[model.runtimeType], model.toMap());
  } else {
    return Future.error("no method mapper found[${model.runtimeType}]");
  }
}

/// The WeChat-Login is under Auth-2.0
/// This method login with native WeChat app.
/// For users without WeChat app, please use [authByQRCode] instead
/// This method only supports getting AuthCode,this is first step to login with WeChat
/// Once AuthCode got, you need to request Access_Token
/// For more information please visit：
/// * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=
@Deprecated("use sendWeChatAuth instead")
Future sendAuth({String openId, @required String scope, String state}) async {
  // "scope": scope, "state": state, "openId": openId

  assert(scope != null && scope.trim().isNotEmpty);
  return await _channel.invokeMethod(
      "sendAuth", {"scope": scope, "state": state, "openId": openId});
}

/// The WeChat-Login is under Auth-2.0
/// This method login with native WeChat app.
/// For users without WeChat app, please use [authByQRCode] instead
/// This method only supports getting AuthCode,this is first step to login with WeChat
/// Once AuthCode got, you need to request Access_Token
/// For more information please visit：
/// * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=
Future sendWeChatAuth(
    {String openId, @required String scope, String state}) async {
  // "scope": scope, "state": state, "openId": openId

  assert(scope != null && scope.trim().isNotEmpty);
  return await _channel.invokeMethod(
      "sendAuth", {"scope": scope, "state": state, "openId": openId});
}

/// Sometimes WeChat  is not installed on users's devices.However we can
/// request a QRCode so that we can get AuthCode by scanning the QRCode
/// All required params must not be null or empty
/// [schemeData] only works on iOS
/// see * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=215238808828h4XN&token=&lang=zh_CN
@Deprecated("use authWeChatByQRCode instead")
Future authByQRCode(
    {@required String appId,
    @required String scope,
    @required String nonceStr,
    @required String timeStamp,
    @required String signature,
    String schemeData}) async {
  assert(appId != null && appId.isNotEmpty);
  assert(scope != null && scope.isNotEmpty);
  assert(nonceStr != null && nonceStr.isNotEmpty);
  assert(timeStamp != null && timeStamp.isNotEmpty);
  assert(signature != null && signature.isNotEmpty);

  return await _channel.invokeMethod("authByQRCode", {
    "appId": appId,
    "scope": scope,
    "nonceStr": nonceStr,
    "timeStamp": timeStamp,
    "signature": signature,
    "schemeData": schemeData
  });
}

/// Sometimes WeChat  is not installed on users's devices.However we can
/// request a QRCode so that we can get AuthCode by scanning the QRCode
/// All required params must not be null or empty
/// [schemeData] only works on iOS
/// see * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=215238808828h4XN&token=&lang=zh_CN
Future authWeChatByQRCode(
    {@required String appId,
    @required String scope,
    @required String nonceStr,
    @required String timeStamp,
    @required String signature,
    String schemeData}) async {
  assert(appId != null && appId.isNotEmpty);
  assert(scope != null && scope.isNotEmpty);
  assert(nonceStr != null && nonceStr.isNotEmpty);
  assert(timeStamp != null && timeStamp.isNotEmpty);
  assert(signature != null && signature.isNotEmpty);

  return await _channel.invokeMethod("authByQRCode", {
    "appId": appId,
    "scope": scope,
    "nonceStr": nonceStr,
    "timeStamp": timeStamp,
    "signature": signature,
    "schemeData": schemeData
  });
}

/// stop auth
@Deprecated("use stopWeChatAuthByQRCode instead")
Future stopAuthByQRCode() async {
  return await _channel.invokeMethod("stopAuthByQRCode");
}

/// stop auth
Future stopWeChatAuthByQRCode() async {
  return await _channel.invokeMethod("stopAuthByQRCode");
}

/// open mini-program
/// see [WXMiniProgramType]
@Deprecated("use launchWeChatMiniProgram instead")
Future launchMiniProgram(
    {@required String username,
    String path,
    WXMiniProgramType miniProgramType = WXMiniProgramType.RELEASE}) async {
  assert(username != null && username.trim().isNotEmpty);
  return await _channel.invokeMethod("launchMiniProgram", {
    "userName": username,
    "path": path,
    "miniProgramType": miniProgramTypeToInt(miniProgramType)
  });
}

/// open mini-program
/// see [WXMiniProgramType]
Future launchWeChatMiniProgram(
    {@required String username,
    String path,
    WXMiniProgramType miniProgramType = WXMiniProgramType.RELEASE}) async {
  assert(username != null && username.trim().isNotEmpty);
  return await _channel.invokeMethod("launchMiniProgram", {
    "userName": username,
    "path": path,
    "miniProgramType": miniProgramTypeToInt(miniProgramType)
  });
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
@Deprecated("use payWithWeChat instead")
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

/// params are from server
Future payWithWeChat(
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

/// subscribe message
@Deprecated("use subscribeWeChatMsg instead")
Future subscribeMsg({
  @required String appId,
  @required int scene,
  @required String templateId,
  String reserved,
}) async {
  return await _channel.invokeMethod(
    "subscribeMsg",
    {
      "appId": appId,
      "scene": scene,
      "templateId": templateId,
      "reserved": reserved,
    },
  );
}

/// subscribe message
Future subscribeWeChatMsg({
  @required String appId,
  @required int scene,
  @required String templateId,
  String reserved,
}) async {
  return await _channel.invokeMethod(
    "subscribeMsg",
    {
      "appId": appId,
      "scene": scene,
      "templateId": templateId,
      "reserved": reserved,
    },
  );
}

/// please read official docs.
@Deprecated("use autoDeDuctWeChat instead")
Future autoDeDuct(
    {@required String appId,
    @required String mchId,
    @required String planId,
    @required String contractCode,
    @required String requestSerial,
    @required String contractDisplayAccount,
    @required String notifyUrl,
    @required String version,
    @required String sign,
    @required String timestamp,
    String returnApp = '3',
    int businessType = 12}) async {
  return await _channel.invokeMethod("autoDeduct", {
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
    "businessType": businessType
  });
}

/// please read official docs.
Future autoDeDuctWeChat(
    {@required String appId,
    @required String mchId,
    @required String planId,
    @required String contractCode,
    @required String requestSerial,
    @required String contractDisplayAccount,
    @required String notifyUrl,
    @required String version,
    @required String sign,
    @required String timestamp,
    String returnApp = '3',
    int businessType = 12}) async {
  return await _channel.invokeMethod("autoDeduct", {
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
    "businessType": businessType
  });
}

Future<bool> openWeChatApp() async {
  return await _channel.invokeMethod("openWXApp");
}

_handleOnAuthByQRCodeFinished(MethodCall methodCall) {
  int errCode = methodCall.arguments["errCode"];
  _authByQRCodeFinishedController.sink.add(AuthByQRCodeResult(
      methodCall.arguments["authCode"],
      _authByQRCodeErrorCodes[errCode] ?? AuthByQRCodeErrorCode.UNKNOWN));
}

const Map<Type, String> _shareModelMethodMapper = {
  WeChatShareTextModel: "shareText",
  WeChatShareImageModel: "shareImage",
  WeChatShareMusicModel: "shareMusic",
  WeChatShareVideoModel: "shareVideo",
  WeChatShareWebPageModel: "shareWebPage",
  WeChatShareMiniProgramModel: "shareMiniProgram",
  WeChatShareFileModel: "shareFile",
};

const Map<int, AuthByQRCodeErrorCode> _authByQRCodeErrorCodes = {
  0: AuthByQRCodeErrorCode.OK,
  -1: AuthByQRCodeErrorCode.NORMAL_ERR,
  -2: AuthByQRCodeErrorCode.NETWORK_ERR,
  -3: AuthByQRCodeErrorCode.JSON_DECODE_ERR,
  -4: AuthByQRCodeErrorCode.CANCEL,
  -5: AuthByQRCodeErrorCode.AUTH_STOPPED
};
