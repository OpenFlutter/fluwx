import '../wechat_type.dart';

///convert [WXMiniProgramType] to int
int miniProgramTypeToInt(WXMiniProgramType type) {
  switch (type) {
    case WXMiniProgramType.PREVIEW:
      return 2;
    case WXMiniProgramType.TEST:
      return 1;
    case WXMiniProgramType.RELEASE:
      return 0;
  }
  return 0;
}
