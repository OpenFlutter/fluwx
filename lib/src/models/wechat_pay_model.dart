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
import 'package:flutter/foundation.dart';

class WeChatPayModel {
  final String appId;
  final String partnerId;
  final String prepayId;
  final String packageValue;
  final String nonceStr;
  final int timeStamp;
  final String sign;
  final String signType;
  final String extData;

  WeChatPayModel(
      {@required this.appId,
      @required this.partnerId,
      @required this.prepayId,
      @required this.packageValue,
      @required this.nonceStr,
      @required this.timeStamp,
      @required this.sign,
      this.signType,
      this.extData});

  Map toMap() {
    return {
      "appId": appId,
      "partnerId": partnerId,
      "prepayId": prepayId,
      "packageValue": packageValue,
      "nonceStr": nonceStr,
      "timeStamp": timeStamp,
      "sign": sign,
      "signType": signType,
      "extData": extData,
    };
  }
}
