/*
 * Copyright (c) 2023.  OpenFlutter Project
 *
 *   Licensed to the Apache Software Foundation (ASF) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  The ASF licenses this
 * file to you under the Apache License, Version 2.0 (the 'License'); you may not
 * use this file except in compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
import 'package:fluwx/fluwx.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fluwx_method_channel.dart';

abstract class FluwxPlatform extends PlatformInterface {
  /// Constructs a FluwxPlatform.
  FluwxPlatform() : super(token: _token);

  static final Object _token = Object();

  static FluwxPlatform _instance = MethodChannelFluwx();

  /// The default instance of [FluwxPlatform] to use.
  ///
  /// Defaults to [MethodChannelFluwx].
  static FluwxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FluwxPlatform] when
  /// they register themselves.
  static set instance(FluwxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<WeChatResponse> get responseEventHandler {
    throw UnimplementedError('responseEventHandler has not been implemented.');
  }

  Future<bool> get isWeChatInstalled {
    throw UnimplementedError('isWeChatInstalled has not been implemented.');
  }

  Future<bool> open(OpenType target) {
    throw UnimplementedError('open() has not been implemented.');
  }

  Future<bool> registerApi({
    required String appId,
    bool doOnIOS = true,
    bool doOnAndroid = true,
    String? universalLink,
  }) {
    throw UnimplementedError('registerWxApi() has not been implemented.');
  }

  Future<String?> getExtMsg() {
    throw UnimplementedError('getExtMsg() has not been implemented.');
  }

  Future<bool> share(WeChatShareModel what) {
    throw UnimplementedError('share() has not been implemented.');
  }

  Future<bool> sendAuth(
      {required String scope,
      String state = 'state',
      bool nonAutomatic = false}) {
    throw UnimplementedError('sendAuth() has not been implemented.');
  }

  Future<bool> authByPhoneLogin({
    required String scope,
    String state = 'state',
  }) async {
    throw UnimplementedError('authByPhoneLogin() has not been implemented.');
  }

  Future<bool> authByQRCode({
    required String appId,
    required String scope,
    required String nonceStr,
    required String timestamp,
    required String signature,
    String? schemeData,
  }) async {
    throw UnimplementedError('authByQRCode() has not been implemented.');
  }

  Future<bool> stopAuthByQRCode() async {
    throw UnimplementedError(
        'stopWeChatAuthByQRCode() has not been implemented.');
  }

  Future<bool> pay(PayType which) {
    throw UnimplementedError('pay() has not been implemented.');
  }

  Future<bool> autoDeduct(AutoDeduct data) {
    throw UnimplementedError('autoDeduct() has not been implemented.');
  }

  Future<bool> authBy(AuthType which) {
    throw UnimplementedError('authBy() has not been implemented.');
  }

  Future<void> attemptToResumeMsgFromWx() {
    throw UnimplementedError(
        'attemptToResumeMsgFromWx() has not been implemented.');
  }

  Future<void> selfCheck() {
    throw UnimplementedError('selfCheck() has not been implemented.');
  }

  Future<bool> get isSupportOpenBusinessView async {
    throw UnimplementedError(
        'isSupportOpenBusinessView() has not been implemented.');
  }
}
