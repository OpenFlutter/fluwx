/*
 * Copyright (c) 2020.  OpenFlutter Project
 *
 *   Licensed to the Apache Software Foundation (ASF) under one or more contributor
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
import 'package:flutter_test/flutter_test.dart';
import 'package:fluwx/src/share/share_models.dart';
import 'package:fluwx/src/wechat_enums.dart';

void main() {
  test("create WeChatTextModel", () {
    var model = WeChatShareTextModel("text", scene: WeChatScene.FAVORITE);
    expect(model.source, "text");
    expect(model.scene, WeChatScene.FAVORITE);
  });

  test("WeChatTextModel toMap", () {
    var map = WeChatShareTextModel("text", scene: WeChatScene.FAVORITE).toMap();
    expect(map["source"], "text");
    expect(map["scene"], 2);
  });
}
