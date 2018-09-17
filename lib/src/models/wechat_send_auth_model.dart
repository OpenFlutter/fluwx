/*
 * Copyright (C) 2018 The OpenFlutter Organization
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'package:flutter/foundation.dart';

class WeChatSendAuthModel {
  final String scope;
  final String state;
  final String openId;

  WeChatSendAuthModel({@required this.scope, this.state, this.openId})
      : assert(scope != null && scope.trim().isNotEmpty);

  Map toMap() {
    return {"scope": scope, "state": state, "openId": openId};
  }
}
