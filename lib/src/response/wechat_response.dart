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

const String _errCode = "errCode";
const String _errStr = "errStr";

typedef BaseWeChatResponse _WeChatResponseInvoker(Map argument);

Map<String, _WeChatResponseInvoker> _nameAndResponseMapper = {
  "onShareResponse": (Map argument) => WeChatShareResponse.fromMap(argument),
  "onAuthResponse": (Map argument) => WeChatAuthResponse.fromMap(argument),
  "onLaunchMiniProgramResponse": (Map argument) =>
      WeChatLaunchMiniProgramResponse.fromMap(argument),
  "onPayResponse": (Map argument) => WeChatPaymentResponse.fromMap(argument),
  "onSubscribeMsgResp": (Map argument) =>
      WeChatSubscribeMsgResponse.fromMap(argument),
  "onAutoDeductResponse": (Map argument) =>
      WeChatAutoDeductResponse.fromMap(argument),
};

class BaseWeChatResponse {
  final int errCode;
  final String errStr;

  bool get isSuccessful => errCode == 0;

  BaseWeChatResponse._(this.errCode, this.errStr);

  /// create response from response pool
  factory BaseWeChatResponse.create(String name, Map argument) =>
      _nameAndResponseMapper[name](argument);
}

class WeChatShareResponse extends BaseWeChatResponse {
  final int type;

  WeChatShareResponse.fromMap(Map map)
      : type = map["type"],
        super._(map[_errCode], map[_errStr]);
}

class WeChatAuthResponse extends BaseWeChatResponse {
  final int type;
  final String country;
  final String lang;
  final String code;
  final String state;

  WeChatAuthResponse.fromMap(Map map)
      : type = map["type"],
        country = map["country"],
        lang = map["lang"],
        code = map["code"],
        state = map["state"],
        super._(map[_errCode], map[_errStr]);

  @override
  bool operator ==(other) {
    if (other is WeChatAuthResponse) {
      return code == other.code &&
          country == other.country &&
          lang == other.lang &&
          state == other.state;
    } else {
      return false;
    }
  }

  @override
  int get hashCode =>
      super.hashCode + errCode.hashCode &
      1345 + errStr.hashCode &
      15 + (code ?? "").hashCode &
      1432;
}

class WeChatLaunchMiniProgramResponse extends BaseWeChatResponse {
  final int type;
  final String extMsg;

  WeChatLaunchMiniProgramResponse.fromMap(Map map)
      : type = map["type"],
        extMsg = map["extMsg"],
        super._(map[_errCode], map[_errStr]);
}

class WeChatPaymentResponse extends BaseWeChatResponse {
  final int type;
  final String extData;

  WeChatPaymentResponse.fromMap(Map map)
      : type = map["type"],
        extData = map["extData"],
        super._(map[_errCode], map[_errStr]);
}

class WeChatSubscribeMsgResponse extends BaseWeChatResponse {
  final String openid;
  final String templateId;
  final String action;
  final String reserved;
  final int scene;

  WeChatSubscribeMsgResponse.fromMap(Map map)
      : openid = map["openid"],
        templateId = map["templateId"],
        action = map["action"],
        reserved = map["reserved"],
        scene = map["scene"],
        super._(map[_errCode], map[_errStr]);
}

class WeChatAutoDeductResponse extends BaseWeChatResponse {
  final int type;
  final int errCode;
  final int businessType;
  final String resultInfo;

  WeChatAutoDeductResponse.fromMap(Map map)
      : type = map["type"],
        errCode = map[_errCode],
        businessType = map["businessType"],
        resultInfo = map["resultInfo"],
        super._(map[_errCode], map[_errStr]);
}
