enum ResponseType { SHARE, AUTH, PAYMENT }

/// response data from WeChat.
class WeChatResponse {
  final Map result;
  final ResponseType type;

  WeChatResponse(this.result, this.type);

  @override
  String toString() {
    return {"type": type, "result": result}.toString();
  }
}
