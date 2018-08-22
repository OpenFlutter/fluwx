class WeChatSendAuthModel {
  final String scope;
  final String state;

  WeChatSendAuthModel(this.scope, this.state) :
        assert(scope != null && scope
            .trim()
            .isNotEmpty);

  Map toMap() {
    return {
      "scope":scope,
      "state":state
    };

  }

}