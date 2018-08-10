class WeChatResponseCode {
  static const int ERR_OK = 0;
  static const int ERR_COMM = -1;
  static const int ERR_USER_CANCEL = -2;
  static const int ERR_SENT_FAILED = -3;
  static const int ERR_AUTH_DENIED = -4;
  static const int ERR_UNSUPPORTED = -5;
  static const int ERR_BAN = -6;
}

class WeChatResponseKey{
  static const String TYPE ="type";
  static const String ERR_CODE ="errCode";
  static const String ERR_STR ="errStr";
  static const String TRANSACTION ="transaction";
  static const String OPEN_ID ="openId";
}