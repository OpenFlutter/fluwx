import 'package:flutter_test/flutter_test.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/src/method_channel/fluwx_method_channel.dart';
import 'package:fluwx/src/method_channel/fluwx_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFluwxPlatform
    with MockPlatformInterfaceMixin
    implements FluwxPlatform {

  @override
  Future<String?> getExtMsg() {
    // TODO: implement getExtMsg
    throw UnimplementedError();
  }

  @override
  Future<bool> get isWeChatInstalled => Future.value(false);

  @override
  Future<bool> registerApi(
      {required String appId,
      bool doOnIOS = true,
      bool doOnAndroid = true,
      String? universalLink}) {
    // TODO: implement registerWxApi
    throw UnimplementedError();
  }

  @override
  Future<bool> sendAuth(
      {required String scope,
      String state = 'state',
      bool nonAutomatic = false}) {
    // TODO: implement sendAuth
    throw UnimplementedError();
  }

  @override
  Future<bool> share(WeChatShareModel what) {
    // TODO: implement share
    throw UnimplementedError();
  }

  @override
  Future<bool> stopAuthByQRCode() {
    // TODO: implement stopWeChatAuthByQRCode
    throw UnimplementedError();
  }

  @override
  Stream<WeChatResponse> get responseEventHandler => throw UnimplementedError();

  @override
  Future<bool> open(OpenType target) {
    throw UnimplementedError();
  }

  @override
  Future<bool> authBy(AuthType which) {
    // TODO: implement authBy
    throw UnimplementedError();
  }

  @override
  Future<bool> authByPhoneLogin({required String scope, String state = 'state'}) {
    // TODO: implement authByPhoneLogin
    throw UnimplementedError();
  }

  @override
  Future<bool> authByQRCode({required String appId, required String scope, required String nonceStr, required String timestamp, required String signature, String? schemeData}) {
    // TODO: implement authByQRCode
    throw UnimplementedError();
  }

  @override
  Future<bool> autoDeduct(AutoDeduct data) {
    // TODO: implement autoDeduct
    throw UnimplementedError();
  }

  @override
  // TODO: implement isSupportOpenBusinessView
  Future<bool> get isSupportOpenBusinessView => throw UnimplementedError();

  @override
  Future<bool> pay(PayType which) {
    // TODO: implement pay
    throw UnimplementedError();
  }

  @override
  Future<void> attemptToResumeMsgFromWx() {
    // TODO: implement attemptToResumeMsgFromWx
    throw UnimplementedError();
  }

  @override
  Future<void> selfCheck() {
    // TODO: implement selfCheck
    throw UnimplementedError();
  }

}

void main() {
  final FluwxPlatform initialPlatform = FluwxPlatform.instance;

  test('$MethodChannelFluwx is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFluwx>());
  });

  test('isWeChatInstalled', () async {
    Fluwx fluwxPlugin = Fluwx();
    MockFluwxPlatform fakePlatform = MockFluwxPlatform();
    FluwxPlatform.instance = fakePlatform;
    expect(await fluwxPlugin.isWeChatInstalled, false);
  });
}
