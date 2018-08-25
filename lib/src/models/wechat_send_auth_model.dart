import 'package:flutter/foundation.dart';
class WeChatSendAuthModel {
  final String scope;
  final String state;
  final String openId;

  WeChatSendAuthModel({
    @required this.scope,
    this.state,
    this.openId }) :
        assert(scope != null && scope
            .trim()
            .isNotEmpty);

  Map toMap() {
    return {
      "scope":scope,
      "state":state,
      "openId":openId
    };

  }

}