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

import 'dart:typed_data';

const String _errCode = 'errCode';
const String _errStr = 'errStr';

typedef BaseWeChatResponse _WeChatResponseInvoker(Map argument);

Map<String, _WeChatResponseInvoker> _nameAndResponseMapper = {
  'onShareResponse': (Map argument) => WeChatShareResponse.fromMap(argument),
  'onAuthResponse': (Map argument) => WeChatAuthResponse.fromMap(argument),
  'onLaunchMiniProgramResponse': (Map argument) =>
      WeChatLaunchMiniProgramResponse.fromMap(argument),
  'onPayResponse': (Map argument) => WeChatPaymentResponse.fromMap(argument),
  'onSubscribeMsgResp': (Map argument) =>
      WeChatSubscribeMsgResponse.fromMap(argument),
  'onWXOpenBusinessWebviewResponse': (Map argument) =>
      WeChatOpenBusinessWebviewResponse.fromMap(argument),
  'onAuthByQRCodeFinished': (Map argument) =>
      WeChatAuthByQRCodeFinishedResponse.fromMap(argument),
  'onAuthGotQRCode': (Map argument) =>
      WeChatAuthGotQRCodeResponse.fromMap(argument),
  'onQRCodeScanned': (Map argument) =>
      WeChatQRCodeScannedResponse.fromMap(argument),
  'onWXShowMessageFromWX': (Map argument) =>
      WeChatShowMessageFromWXRequest.fromMap(argument),
  'onWXOpenCustomerServiceChatResponse': (Map argument) =>
      WeChatOpenCustomerServiceChatResponse.fromMap(argument),
  "onOpenBusinessViewResponse": (Map argument) =>
      WeChatOpenBusinessViewResponse.fromMap(argument),
  "onOpenWechatInvoiceResponse": (Map argument) =>
      WeChatOpenInvoiceResponse.fromMap(argument),
};

class BaseWeChatResponse {
  BaseWeChatResponse._(this.errCode, this.errStr);

  /// Create response from the response pool.
  factory BaseWeChatResponse.create(String name, Map argument) {
    var result = _nameAndResponseMapper[name];
    if (result == null) {
      throw ArgumentError("Can't found instance of $name");
    }
    return result(argument);
  }

  final int? errCode;
  final String? errStr;

  bool get isSuccessful => errCode == 0;
}

class WeChatOpenInvoiceResponse extends BaseWeChatResponse {
  String? cardItemList;
  WeChatOpenInvoiceResponse.fromMap(Map map)
      : cardItemList = map["cardItemList"],
        super._(map[_errCode], map[_errStr]);
}

class WeChatShareResponse extends BaseWeChatResponse {
  WeChatShareResponse.fromMap(Map map)
      : type = map['type'],
        super._(map[_errCode], map[_errStr]);

  final int type;
}

class WeChatAuthResponse extends BaseWeChatResponse {
  WeChatAuthResponse.fromMap(Map map)
      : type = map['type'],
        country = map['country'],
        lang = map['lang'],
        code = map['code'],
        state = map['state'],
        super._(map[_errCode], map[_errStr]);

  final int type;
  final String? country;
  final String? lang;
  final String? code;
  final String? state;

  @override
  bool operator ==(other) {
    return other is WeChatAuthResponse &&
        code == other.code &&
        country == other.country &&
        lang == other.lang &&
        state == other.state;
  }

  @override
  int get hashCode =>
      super.hashCode + errCode.hashCode &
      1345 + errStr.hashCode &
      15 + (code ?? '').hashCode &
      1432;
}

class WeChatLaunchMiniProgramResponse extends BaseWeChatResponse {
  WeChatLaunchMiniProgramResponse.fromMap(Map map)
      : type = map['type'],
        extMsg = map['extMsg'],
        super._(map[_errCode], map[_errStr]);

  final int? type;
  final String? extMsg;
}

class WeChatPaymentResponse extends BaseWeChatResponse {
  WeChatPaymentResponse.fromMap(Map map)
      : type = map['type'],
        extData = map['extData'],
        super._(map[_errCode], map[_errStr]);

  final int type;
  final String? extData;
}

class WeChatOpenCustomerServiceChatResponse extends BaseWeChatResponse {
  WeChatOpenCustomerServiceChatResponse.fromMap(Map map)
      : extMsg = map['extMsg'],
        super._(map[_errCode], map[_errStr]);

  final String? extMsg;
}

class WeChatOpenBusinessViewResponse extends BaseWeChatResponse {
  final String? extMsg;
  final String? openid;
  final String? businessType;
  final int? type;

  WeChatOpenBusinessViewResponse.fromMap(Map map)
      : extMsg = map["extMsg"],
        openid = map["openid"],
        businessType = map["businessType"],
        type = map["type"],
        super._(map[_errCode], map[_errStr]);
}

class WeChatSubscribeMsgResponse extends BaseWeChatResponse {
  WeChatSubscribeMsgResponse.fromMap(Map map)
      : openid = map['openid'],
        templateId = map['templateId'],
        action = map['action'],
        reserved = map['reserved'],
        scene = map['scene'],
        super._(map[_errCode], map[_errStr]);

  final String? openid;
  final String? templateId;
  final String? action;
  final String? reserved;
  final int scene;
}

class WeChatOpenBusinessWebviewResponse extends BaseWeChatResponse {
  WeChatOpenBusinessWebviewResponse.fromMap(Map map)
      : type = map['type'],
        errCode = map[_errCode],
        businessType = map['businessType'],
        resultInfo = map['resultInfo'],
        super._(map[_errCode], map[_errStr]);

  final int? type;
  final int errCode;
  final int? businessType;
  final String resultInfo;
}

class WeChatAuthByQRCodeFinishedResponse extends BaseWeChatResponse {
  WeChatAuthByQRCodeFinishedResponse.fromMap(Map map)
      : authCode = map['authCode'],
        qrCodeErrorCode = (_authByQRCodeErrorCodes[_errCode] ??
            AuthByQRCodeErrorCode.UNKNOWN),
        super._(map[_errCode], map[_errStr]);

  final String? authCode;
  final AuthByQRCodeErrorCode? qrCodeErrorCode;
}

///[qrCode] in memory.
class WeChatAuthGotQRCodeResponse extends BaseWeChatResponse {
  WeChatAuthGotQRCodeResponse.fromMap(Map map)
      : qrCode = map['qrCode'],
        super._(map[_errCode], map[_errStr]);

  final Uint8List? qrCode;
}

class WeChatQRCodeScannedResponse extends BaseWeChatResponse {
  WeChatQRCodeScannedResponse.fromMap(Map map)
      : super._(map[_errCode], map[_errStr]);
}

// 获取微信打开App时携带的参数
class WeChatShowMessageFromWXRequest extends BaseWeChatResponse {
  WeChatShowMessageFromWXRequest.fromMap(Map map)
      : extMsg = map['extMsg'],
        super._(0, '');

  final String? extMsg;
}

enum AuthByQRCodeErrorCode {
  OK, // WechatAuth_Err_OK(0)
  NORMAL_ERR, // WechatAuth_Err_NormalErr(-1)
  NETWORK_ERR, // WechatAuth_Err_NetworkErr(-2)
  JSON_DECODE_ERR, // WechatAuth_Err_JsonDecodeErr(-3), WechatAuth_Err_GetQrcodeFailed on iOS
  CANCEL, // WechatAuth_Err_Cancel(-4)
  TIMEOUT, // WechatAuth_Err_Timeout(-5)
  AUTH_STOPPED, // WechatAuth_Err_Auth_Stopped(-6), Android only
  UNKNOWN
}

const Map<int, AuthByQRCodeErrorCode> _authByQRCodeErrorCodes = {
  0: AuthByQRCodeErrorCode.OK,
  -1: AuthByQRCodeErrorCode.NORMAL_ERR,
  -2: AuthByQRCodeErrorCode.NETWORK_ERR,
  -3: AuthByQRCodeErrorCode.JSON_DECODE_ERR,
  -4: AuthByQRCodeErrorCode.CANCEL,
  -5: AuthByQRCodeErrorCode.AUTH_STOPPED
};
