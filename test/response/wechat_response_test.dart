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

import 'package:flutter_test/flutter_test.dart';
import 'package:fluwx/fluwx.dart';

void main() {
  group("create response", () {
    test("WeChatShareResponse", () {
      var response = BaseWeChatResponse.create(
          "onShareResponse", {"type": 1, "errCode": 1, "errStr": "hehe"});
      expect(response is WeChatShareResponse, true);
      var casted = response as WeChatShareResponse;
      expect(casted.type, 1);
      expect(casted.errCode, 1);
      expect(casted.errStr, "hehe");
    });

    test("WeChatAuthResponse", () {
      var response = BaseWeChatResponse.create("onAuthResponse", {
        "type": 1,
        "errCode": 1,
        "errStr": "hehe",
        "country": "cn",
        "lang": "lang",
        "code": "code",
        "state": "ok"
      });
      expect(response is WeChatAuthResponse, true);
      var casted = response as WeChatAuthResponse;
      expect(casted.type, 1);
      expect(casted.errCode, 1);
      expect(casted.errStr, "hehe");
      expect(casted.country, "cn");
      expect(casted.lang, "lang");
      expect(casted.code, "code");
      expect(casted.state, "ok");
    });

    test("onLaunchMiniProgramResponse", () {
      var response = BaseWeChatResponse.create("onLaunchMiniProgramResponse",
          {"type": 1, "errCode": 1, "errStr": "hehe", "extMsg": "extMsg"});
      expect(response is WeChatLaunchMiniProgramResponse, true);
      var casted = response as WeChatLaunchMiniProgramResponse;
      expect(casted.type, 1);
      expect(casted.errCode, 1);
      expect(casted.errStr, "hehe");
      expect(casted.extMsg, "extMsg");
    });

    test("WeChatPaymentResponse", () {
      var response = BaseWeChatResponse.create("onPayResponse",
          {"type": 1, "errCode": 1, "errStr": "hehe", "extData": "extData"});
      expect(response is WeChatPaymentResponse, true);
      var casted = response as WeChatPaymentResponse;
      expect(casted.type, 1);
      expect(casted.errCode, 1);
      expect(casted.errStr, "hehe");
      expect(casted.extData, "extData");
    });

    test("WeChatSubscribeMsgResponse", () {
      var response = BaseWeChatResponse.create("onSubscribeMsgResp", {
        "type": 1,
        "errCode": 1,
        "errStr": "hehe",
        "openid": "425235131",
        "templateId": "4252345",
        "action": "action",
        "reserved": "reserved",
        "scene": 1
      });
      expect(response is WeChatSubscribeMsgResponse, true);
      var casted = response as WeChatSubscribeMsgResponse;
      expect(casted.errCode, 1);
      expect(casted.errStr, "hehe");
      expect(casted.openid, "425235131");
      expect(casted.templateId, "4252345");
      expect(casted.action, "action");
      expect(casted.reserved, "reserved");
      expect(casted.scene, 1);
    });

    test("WeChatAutoDeductResponse", () {
      var response = BaseWeChatResponse.create("onAutoDeductResponse", {
        "type": 1,
        "errCode": 0,
        "errStr": "hehe",
        "businessType": 2,
        "resultInfo": "resultInfo"
      });
      expect(response is WeChatOpenBusinessWebviewResponse, true);
      var casted = response as WeChatOpenBusinessWebviewResponse;
      assert(casted.isSuccessful);
      expect(casted.type, 1);
      expect(casted.errCode, 0);
      expect(casted.errStr, "hehe");
      expect(casted.resultInfo, "resultInfo");
      expect(casted.businessType, 2);
    });
  });
}
