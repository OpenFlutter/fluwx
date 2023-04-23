import 'package:flutter_test/flutter_test.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/src/method_channel/fluwx_method_channel.dart';
import 'package:fluwx/src/method_channel/fluwx_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFluwxPlatform
    with MockPlatformInterfaceMixin
    implements FluwxPlatform {
  @override
  Future<bool> authByPhoneLogin(
      {required String scope, String state = 'state'}) {
    // TODO: implement authByPhoneLogin
    throw UnimplementedError();
  }

  @override
  Future<bool> authByQRCode(
      {required String appId,
      required String scope,
      required String nonceStr,
      required String timestamp,
      required String signature,
      String? schemeData}) {
    // TODO: implement authByQRCode
    throw UnimplementedError();
  }

  @override
  Future<bool> autoDeDuct(
      {required String appId,
      required String mchId,
      required String planId,
      required String contractCode,
      required String requestSerial,
      required String contractDisplayAccount,
      required String notifyUrl,
      required String version,
      required String sign,
      required String timestamp,
      String returnApp = '3',
      int businessType = 12}) {
    // TODO: implement autoDeDuct
    throw UnimplementedError();
  }

  @override
  Future<bool> autoDeductV2(Map<String, String> queryInfo,
      {int businessType = 12}) {
    // TODO: implement autoDeductV2
    throw UnimplementedError();
  }

  @override
  Future<bool> checkSupportOpenBusinessView() {
    // TODO: implement checkSupportOpenBusinessView
    throw UnimplementedError();
  }

  @override
  Future<String?> getExtMsg() {
    // TODO: implement getExtMsg
    throw UnimplementedError();
  }

  @override
  Future<bool> get isWeChatInstalled => Future.value(false);

  @override
  Future<bool> launchMiniProgram(
      {required String username,
      String? path,
      WXMiniProgramType miniProgramType = WXMiniProgramType.release}) {
    // TODO: implement launchMiniProgram
    throw UnimplementedError();
  }

  @override
  Future<bool> openBusinessView(
      {required String businessType, required String query}) {
    // TODO: implement openBusinessView
    throw UnimplementedError();
  }

  @override
  Future<bool> openCustomerServiceChat(
      {required String url, required String corpId}) {
    // TODO: implement openCustomerServiceChat
    throw UnimplementedError();
  }

  @override
  Future<bool> openInvoice(
      {required String appId,
      required String cardType,
      String locationId = "",
      String cardId = "",
      String canMultiSelect = "1"}) {
    // TODO: implement openInvoice
    throw UnimplementedError();
  }

  @override
  Future<bool> openWeChatApp() {
    // TODO: implement openWeChatApp
    throw UnimplementedError();
  }

  @override
  Future<bool> pay(
      {required String appId,
      required String partnerId,
      required String prepayId,
      required String packageValue,
      required String nonceStr,
      required int timestamp,
      required String sign,
      String? signType,
      String? extData}) {
    // TODO: implement pay
    throw UnimplementedError();
  }

  @override
  Future<bool> payWithHongKongWallet({required String prepayId}) {
    // TODO: implement payWithHongKongWallet
    throw UnimplementedError();
  }

  @override
  Future<bool> registerWxApi(
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
  Future<bool> stopWeChatAuthByQRCode() {
    // TODO: implement stopWeChatAuthByQRCode
    throw UnimplementedError();
  }

  @override
  Future<bool> subscribeMsg(
      {required String appId,
      required int scene,
      required String templateId,
      String? reserved}) {
    // TODO: implement subscribeMsg
    throw UnimplementedError();
  }

  @override
  // TODO: implement responseEventHandler
  Stream<WeChatResponse> get responseEventHandler => throw UnimplementedError();

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
