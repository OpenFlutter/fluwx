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

typedef _WeChatResponseInvoker = WeChatResponse Function(Map argument);

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
  "onWXLaunchFromWX": (Map argument) =>
      WeChatLaunchFromWXRequest.fromMap(argument),
};

sealed class WeChatResponse {
  WeChatResponse._(this.errCode, this.errStr);

  /// Create response from the response pool.
  factory WeChatResponse.create(String name, Map argument) {
    var result = _nameAndResponseMapper[name];
    if (result == null) {
      throw ArgumentError("Can't found instance of $name");
    }
    return result(argument);
  }

  final int? errCode;
  final String? errStr;

  bool get isSuccessful => errCode == 0;

  Record toRecord() {
    return ();
  }
}

class WeChatOpenInvoiceResponse extends WeChatResponse {
  String? cardItemList;

  WeChatOpenInvoiceResponse.fromMap(Map map)
      : cardItemList = map["cardItemList"],
        super._(map[_errCode], map[_errStr]);

  @override
  Record toRecord() {
    return (errCode: errCode, errStr: errStr, cardItemList: cardItemList);
  }
}

class WeChatShareResponse extends WeChatResponse {
  WeChatShareResponse.fromMap(Map map)
      : type = map['type'],
        super._(map[_errCode], map[_errStr]);

  final int type;

  @override
  Record toRecord() {
    return (errCode: errCode, errStr: errStr, type: type);
  }
}

class WeChatAuthResponse extends WeChatResponse {
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
  Record toRecord() {
    return (
      errCode: errCode,
      errStr: errStr,
      type: type,
      country: country,
      lang: lang,
      code: code,
      state: state
    );
  }
}

class WeChatLaunchMiniProgramResponse extends WeChatResponse {
  WeChatLaunchMiniProgramResponse.fromMap(Map map)
      : type = map['type'],
        extMsg = map['extMsg'],
        super._(map[_errCode], map[_errStr]);

  final int? type;
  final String? extMsg;

  @override
  Record toRecord() {
    return (errCode: errCode, errStr: errStr, type: type, extMsg: extMsg);
  }
}

class WeChatPaymentResponse extends WeChatResponse {
  WeChatPaymentResponse.fromMap(Map map)
      : type = map['type'],
        extData = map['extData'],
        super._(map[_errCode], map[_errStr]);

  final int type;
  final String? extData;

  @override
  Record toRecord() {
    return (errCode: errCode, errStr: errStr, type: type, extData: extData);
  }
}

class WeChatOpenCustomerServiceChatResponse extends WeChatResponse {
  WeChatOpenCustomerServiceChatResponse.fromMap(Map map)
      : extMsg = map['extMsg'],
        super._(map[_errCode], map[_errStr]);

  final String? extMsg;

  @override
  Record toRecord() {
    return (errCode: errCode, errStr: errStr, extMsg: extMsg);
  }
}

class WeChatOpenBusinessViewResponse extends WeChatResponse {
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

  @override
  Record toRecord() {
    return (
      errCode: errCode,
      errStr: errStr,
      type: type,
      extMsg: extMsg,
      openid: openid,
      businessType: businessType
    );
  }
}

class WeChatSubscribeMsgResponse extends WeChatResponse {
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

  @override
  Record toRecord() {
    return (
      errCode: errCode,
      errStr: errStr,
      openid: openid,
      templateId: templateId,
      action: action,
      reserved: reserved,
      scene: scene
    );
  }
}

class WeChatOpenBusinessWebviewResponse extends WeChatResponse {
  WeChatOpenBusinessWebviewResponse.fromMap(Map map)
      : type = map['type'],
        businessType = map['businessType'],
        resultInfo = map['resultInfo'],
        super._(map[_errCode], map[_errStr]);

  final int? type;
  final int? businessType;
  final String resultInfo;

  @override
  Record toRecord() {
    return (
      errCode: errCode,
      errStr: errStr,
      type: type,
      businessType: businessType,
      resultInfo: resultInfo
    );
  }
}

class WeChatAuthByQRCodeFinishedResponse extends WeChatResponse {
  WeChatAuthByQRCodeFinishedResponse.fromMap(Map map)
      : authCode = map['authCode'],
        qrCodeErrorCode = (_authByQRCodeErrorCodes[_errCode] ??
            AuthByQRCodeErrorCode.unknown),
        super._(map[_errCode], map[_errStr]);

  final String? authCode;
  final AuthByQRCodeErrorCode? qrCodeErrorCode;

  @override
  Record toRecord() {
    return (
      errCode: errCode,
      errStr: errStr,
      authCode: authCode,
      qrCodeErrorCode: qrCodeErrorCode,
    );
  }
}

///[qrCode] in memory.
class WeChatAuthGotQRCodeResponse extends WeChatResponse {
  WeChatAuthGotQRCodeResponse.fromMap(Map map)
      : qrCode = map['qrCode'],
        super._(map[_errCode], map[_errStr]);

  final Uint8List? qrCode;

  @override
  Record toRecord() {
    return (qrCode: qrCode);
  }
}

class WeChatQRCodeScannedResponse extends WeChatResponse {
  WeChatQRCodeScannedResponse.fromMap(Map map)
      : super._(map[_errCode], map[_errStr]);

  @override
  Record toRecord() {
    return (errCode: errCode, errStr: errStr);
  }
}

// 获取微信打开App时携带的参数
class WeChatShowMessageFromWXRequest extends WeChatResponse {
  final String? country;
  final String? lang;
  final String? messageAction;
  final String? description;

  WeChatShowMessageFromWXRequest.fromMap(Map map)
      : extMsg = map['extMsg'],
        country = map['country'],
        messageAction = map['messageAction'],
        description = map["description"],
        lang = map["lang"],
        super._(0, '');

  final String? extMsg;

  @override
  Record toRecord() {
    return (
      errCode: errCode,
      errStr: errStr,
      country: country,
      lang: lang,
      messageAction: messageAction,
      description: description,
      extMsg: extMsg,
    );
  }
}

class WeChatLaunchFromWXRequest extends WeChatResponse {
  final String? country;
  final String? lang;
  final String? messageAction;

  WeChatLaunchFromWXRequest.fromMap(Map map)
      : extMsg = map['extMsg'],
        country = map['country'],
        messageAction = map['messageAction'],
        lang = map["lang"],
        super._(0, '');

  final String? extMsg;

  @override
  Record toRecord() {
    return (
      errCode: errCode,
      errStr: errStr,
      country: country,
      lang: lang,
      messageAction: messageAction,
      extMsg: extMsg,
    );
  }
}

enum AuthByQRCodeErrorCode {
  ok, // WechatAuth_Err_OK(0)
  normalErr, // WechatAuth_Err_NormalErr(-1)
  networkErr, // WechatAuth_Err_NetworkErr(-2)
  jsonDecodeErr, // WechatAuth_Err_JsonDecodeErr(-3), WechatAuth_Err_GetQrcodeFailed on iOS
  cancel, // WechatAuth_Err_Cancel(-4)
  timeout, // WechatAuth_Err_Timeout(-5)
  authStopped, // WechatAuth_Err_Auth_Stopped(-6), Android only
  unknown
}

const Map<int, AuthByQRCodeErrorCode> _authByQRCodeErrorCodes = {
  0: AuthByQRCodeErrorCode.ok,
  -1: AuthByQRCodeErrorCode.normalErr,
  -2: AuthByQRCodeErrorCode.networkErr,
  -3: AuthByQRCodeErrorCode.jsonDecodeErr,
  -4: AuthByQRCodeErrorCode.cancel,
  -5: AuthByQRCodeErrorCode.authStopped
};
