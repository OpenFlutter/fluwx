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
import '../wechat_type.dart';
class WeChatLaunchMiniProgramModel {
  final String username;
  final String path;
  final WXMiniProgramType miniprogramtype;

  WeChatLaunchMiniProgramModel({@required this.username, this.path, this.miniprogramtype})
      : assert(username != null && username.trim().isNotEmpty);

  Map toMap() {
    return {"userName": username, "path": path, "miniProgramType": miniprogramtype};
  }
}