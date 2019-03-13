//WechatAuth_Err_OK(0),
//WechatAuth_Err_NormalErr(-1),
//WechatAuth_Err_NetworkErr(-2),
//WechatAuth_Err_JsonDecodeErr(-3),
//WechatAuth_Err_Cancel(-4),
//WechatAuth_Err_Timeout(-5),
//WechatAuth_Err_Auth_Stopped(-6);
///[AuthByQRCodeErrorCode.JSON_DECODE_ERR] means WechatAuth_Err_GetQrcodeFailed when platform is iOS
///only Android will get [AUTH_STOPPED]
enum AuthByQRCodeErrorCode {
  OK,
  NORMAL_ERR,
  NETWORK_ERR,
  JSON_DECODE_ERR,
  CANCEL,
  TIMEOUT,
  AUTH_STOPPED,
  UNKNOWN
}

/// authCode is [null] if [errorCode] isn't [AuthByQRCodeErrorCode.OK]
class AuthByQRCodeResult {
  final String authCode;
  final AuthByQRCodeErrorCode errorCode;

  AuthByQRCodeResult(this.authCode, this.errorCode);
}
