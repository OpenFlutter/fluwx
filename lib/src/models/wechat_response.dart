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
//enum WeChatResponseType { SHARE, AUTH, PAYMENT }

/// response data from WeChat.
//class WeChatResponse {
//  final Map result;
//  final WeChatResponseType type;
//
//  WeChatResponse(this.result, this.type);
//
//  @override
//  String toString() {
//    return {"type": type, "result": result}.toString();
//  }
//}

class WeChatShareResponse {
  final String errStr;
  final String androidTransaction;
  final int type;
  final int errCode;
  final String androidOpenId;
  final String iOSDescription;
  final String iOSCountry;
  final String iOSLang;

  WeChatShareResponse.fromMap(Map map)
      : errStr = map["errStr"],
        androidTransaction = map["transaction"],
        type = map["type"],
        errCode = map["errCode"],
        androidOpenId = map["openId"],
        iOSDescription = map["description"],
        iOSCountry = map["country"],
        iOSLang = map["lang"];
}

class WeChatAuthResponse {
  final String errStr;
  final int type;
  final int errCode;
  final String androidOpenId;
  final String iOSDescription;
  final String country;
  final String lang;
  final String code;
  final String androidUrl;
  final String state;
  final String androidTransaction;

  WeChatAuthResponse.fromMap(Map map)
      : errStr = map["errStr"],
        type = map["type"],
        errCode = map["errCode"],
        androidOpenId = map["openId"],
        iOSDescription = map["description"],
        country = map["country"],
        lang = map["lang"],
        code = map["code"],
        androidUrl = map["url"],
        state = map["state"],
        androidTransaction = map["transaction"];
}

class WeChatLaunchMiniProgramResponse {
  final String errStr;
  final int type;
  final int errCode;
  final String androidOpenId;
  final String iOSDescription;
  final String androidTransaction;
  final String extMsg;

  WeChatLaunchMiniProgramResponse.fromMap(Map map)
      : errStr = map["errStr"],
        type = map["type"],
        errCode = map["errCode"],
        androidOpenId = map["openId"],
        iOSDescription = map["description"],
        androidTransaction = map["transaction"],
        extMsg = map["extMsg"];
}

class WeChatPaymentResponse {
  final String errStr;
  final int type;
  final int errCode;
  final String androidOpenId;
  final String iOSDescription;
  final String androidPrepayId;
  final String extData;
  final String androidTransaction;

  WeChatPaymentResponse.fromMap(Map map)
      : errStr = map["errStr"],
        type = map["type"],
        errCode = map["errCode"],
        androidOpenId = map["openId"],
        iOSDescription = map["description"],
        androidPrepayId = map["prepayId"],
        extData = map["extData"],
        androidTransaction = map["transaction"];
}

class WeChatSubscribeMsgResp {
  final String openid;
  final String templateId;
  final String action;
  final String reserved;
  final int scene;

  WeChatSubscribeMsgResp.fromMap(Map map)
      : openid = map["openid"],
        templateId = map["templateId"],
        action = map["action"],
        reserved = map["reserved"],
        scene = map["scene"];
}
