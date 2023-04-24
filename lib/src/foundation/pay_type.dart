part of 'arguments.dart';

sealed class PayType with _Argument {}

/// request payment with WeChat.
/// Read the official document for more detail.
/// [timestamp] is int because [timestamp] will be mapped to Unit32.
class Payment extends PayType {
  final String appId;
  final String partnerId;
  final String prepayId;
  final String packageValue;
  final String nonceStr;
  final int timestamp;
  final String sign;
  final String? signType;
  final String? extData;

  Payment({
    required this.appId,
    required this.partnerId,
    required this.prepayId,
    required this.packageValue,
    required this.nonceStr,
    required this.timestamp,
    required this.sign,
    this.signType,
    this.extData,
  });

  @override
  Map<String, dynamic> get arguments => {
        'appId': appId,
        'partnerId': partnerId,
        'prepayId': prepayId,
        'packageValue': packageValue,
        'nonceStr': nonceStr,
        'timeStamp': timestamp,
        'sign': sign,
        'signType': signType,
        'extData': extData,
      };
}

/// request Hong Kong Wallet payment with WeChat.
/// Read the official document for more detail.
class HongKongWallet extends PayType {
  final String prepayId;

  HongKongWallet({required this.prepayId});

  @override
  Map<String, dynamic> get arguments => {
        'prepayId': prepayId,
      };
}
