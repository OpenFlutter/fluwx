class WeChatPayModel{
  final appId;
  final partnerId;
  final prepayId;
  final packageValue;
  final nonceStr;
  final timeStamp;
  final sign;
  final signType;
  final extData;


  WeChatPayModel(this.appId, this.partnerId, this.prepayId, this.packageValue,
      this.nonceStr, this.timeStamp, this.sign,{this.signType, this.extData});

  Map toMap() {
    return {
      "appId":appId,
      "partnerId":partnerId,
      "prepayId":prepayId,
      "packageValue":packageValue,
      "nonceStr":nonceStr,
      "timeStamp":timeStamp,
      "sign":sign,
      "signType":signType,
      "extData":extData,
    };

  }

}