import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluwx/src/method_channel/fluwx_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFluwx platform = MethodChannelFluwx();
  const MethodChannel channel = MethodChannel('fluwx');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
  });
}
