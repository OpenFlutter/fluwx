/*
 * Copyright (c) 2023.  OpenFlutter Project
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  The ASF licenses this
 * file to you under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

import 'dart:async';

import 'foundation/arguments.dart';
import 'method_channel/fluwx_platform_interface.dart';
import 'response/wechat_response.dart';

class Fluwx {
  late final WeakReference<void Function(WeChatResponse event)>
      responseListener;

  final List<Function(WeChatResponse response)> _responseListeners = [];

  Fluwx() {
    responseListener = WeakReference((event) {
      for (var listener in _responseListeners) {
        listener(event);
      }
    });
    final target = responseListener.target;
    if (target != null) {
      FluwxPlatform.instance.responseEventHandler.listen(target);
    }
  }

  Future<bool> get isWeChatInstalled =>
      FluwxPlatform.instance.isWeChatInstalled;

  /// Open given target. See [OpenType] for more details
  Future<bool> open({required OpenType target}) {
    return FluwxPlatform.instance.open(target);
  }

  /// It's ok if you register multi times.
  /// [appId] is not necessary.
  /// if [doOnIOS] is true ,fluwx will register WXApi on iOS.
  /// if [doOnAndroid] is true, fluwx will register WXApi on Android.
  /// [universalLink] is required if you want to register on iOS.
  Future<bool> registerApi({
    required String appId,
    bool doOnIOS = true,
    bool doOnAndroid = true,
    String? universalLink,
  }) async {
    return FluwxPlatform.instance.registerApi(
        appId: appId,
        doOnAndroid: doOnAndroid,
        doOnIOS: doOnIOS,
        universalLink: universalLink);
  }

  /// Share your requests to WeChat.
  /// This depends on the actual type of [what].
  Future<bool> share(WeChatShareModel what) async {
    return FluwxPlatform.instance.share(what);
  }

  /// Login by WeChat.See [AuthType] for more details.
  Future<bool> authBy({required AuthType which}) async {
    return FluwxPlatform.instance.authBy(which);
  }

  /// please read * [official docs](https://pay.weixin.qq.com/wiki/doc/api/wxpay_v2/papay/chapter3_2.shtml).
  Future<bool> autoDeduct({required AutoDeduct data}) async {
    return FluwxPlatform.instance.autoDeduct(data);
  }

  Future<bool> get isSupportOpenBusinessView async =>
      await FluwxPlatform.instance.isSupportOpenBusinessView;

  Future<String?> getExtMsg() async {
    return FluwxPlatform.instance.getExtMsg();
  }

  Future<bool> pay({required PayType which}) async {
    return FluwxPlatform.instance.pay(which);
  }

  /// Subscribe responses from WeChat
  subscribeResponse(Function(WeChatResponse response) listener) {
    _responseListeners.add(listener);
  }

  /// Unsubscribe responses from WeChat
  unsubscribeResponse(Function(WeChatResponse response) listener) {
    _responseListeners.remove(listener);
  }
}
