import '../response/wechat_response.dart';

typedef WeChatResponseSubscriber = Function(WeChatResponse response);
mixin FluwxCancelable {
  cancel();
}

class FluwxCancelableImpl implements FluwxCancelable {
  final Function onCancel;

  FluwxCancelableImpl({required this.onCancel});

  @override
  cancel() {
    onCancel();
  }
}
