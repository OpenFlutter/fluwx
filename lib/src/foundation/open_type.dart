part of 'arguments.dart';

sealed class OpenType with _Argument {}

/// Just open WeChat app.
class WeChatApp extends OpenType {}

/// Open WeChat browser with given url.
class Browser extends OpenType {
  final String url;

  Browser(this.url);

  @override
  Map<String, dynamic> get arguments => {'url': url};
}

/// Rank list
class RankList extends OpenType {}

/// see * https://pay.weixin.qq.com/wiki/doc/apiv3_partner/Offline/apis/chapter6_2_1.shtml
class BusinessView extends OpenType {
  final String businessType;
  final String query;

  BusinessView({required this.businessType, required this.query});

  @override
  Map<String, dynamic> get arguments =>
      {"businessType": businessType, "query": query};
}

class Invoice extends OpenType {
  final String appId;
  final String cardType;
  final String locationId;
  final String cardId;
  final String canMultiSelect;

  Invoice(
      {required this.appId,
      required this.cardType,
      this.locationId = "",
      this.cardId = "",
      this.canMultiSelect = "1"});

  @override
  Map<String, dynamic> get arguments => {
        "appId": appId,
        "cardType": cardType,
        "locationId": locationId,
        "cardId": cardId,
        "canMultiSelect": canMultiSelect
      };
}

class CustomerServiceChat extends OpenType {
  final String corpId;
  final String url;

  CustomerServiceChat({required this.corpId, required this.url});

  @override
  Map<String, dynamic> get arguments => {"corpId": corpId, "url": url};
}

/// open mini-program
/// see [WXMiniProgramType]
class MiniProgram extends OpenType {
  final String username;
  final String? path;
  final WXMiniProgramType miniProgramType;

  MiniProgram({
    required this.username,
    this.path,
    this.miniProgramType = WXMiniProgramType.release,
  }) : assert(username.trim().isNotEmpty);

  @override
  Map<String, dynamic> get arguments => {
        'userName': username,
        'path': path,
        'miniProgramType': miniProgramType.value
      };
}

/// See *https://developers.weixin.qq.com/doc/oplatform/Mobile_App/One-time_subscription_info.html for more detail
class SubscribeMessage extends OpenType {
  final String appId;
  final int scene;
  final String templateId;
  final String? reserved;

  SubscribeMessage({
    required this.appId,
    required this.scene,
    required this.templateId,
    this.reserved,
  });

  @override
  Map<String, dynamic> get arguments => {
        'appId': appId,
        'scene': scene,
        'templateId': templateId,
        'reserved': reserved,
      };
}
