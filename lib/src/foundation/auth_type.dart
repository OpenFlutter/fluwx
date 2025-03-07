part of 'arguments.dart';

/// The base class for all AuthType
sealed class AuthType with _Argument {}

/// The WeChat-Login is under Auth-2.0
/// This method login with native WeChat app.
/// For users without WeChat app, please use [QRCode] instead
/// This method only supports getting AuthCode,this is first step to login with WeChat
/// Once AuthCode got, you need to request Access_Token
/// For more information please visit：
/// * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=
class NormalAuth extends AuthType {
  final String scope;
  final String state;
  final bool nonAutomatic;

  NormalAuth(
      {required this.scope, this.state = 'state', this.nonAutomatic = false})
      : assert(scope.trim().isNotEmpty);

  @override
  Map<String, dynamic> get arguments =>
      {'scope': scope, 'state': state, 'nonAutomatic': nonAutomatic};
}

/// Sometimes WeChat  is not installed on users's devices.However we can
/// request a QRCode so that we can get AuthCode by scanning the QRCode
/// All required params must not be null or empty
/// [schemeData] only works on iOS
/// see * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=215238808828h4XN&token=&lang=zh_CN
class QRCode extends AuthType {
  final String appId;
  final String scope;
  final String nonceStr;
  final String timestamp;
  final String signature;
  final String? schemeData;

  QRCode({
    required this.appId,
    required this.scope,
    required this.nonceStr,
    required this.timestamp,
    required this.signature,
    this.schemeData,
  })  : assert(appId.isNotEmpty),
        assert(scope.isNotEmpty),
        assert(nonceStr.isNotEmpty),
        assert(timestamp.isNotEmpty),
        assert(signature.isNotEmpty);

  @override
  Map<String, dynamic> get arguments => {
        'appId': appId,
        'scope': scope,
        'nonceStr': nonceStr,
        'timeStamp': timestamp,
        'signature': signature,
        'schemeData': schemeData
      };
}

/// Currently only support iOS
class PhoneLogin extends AuthType {
  final String scope;
  final String state;

  PhoneLogin({
    required this.scope,
    this.state = 'state',
  });

  @override
  Map<String, dynamic> get arguments => {'scope': scope, 'state': state};
}
