import 'package:flutter/foundation.dart';

class WeChatPayModel {
  final appId;
  final partnerId;
  final prepayId;
  final packageValue;
  final nonceStr;
  final timeStamp;
  final sign;
  final signType;
  final extData;

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
