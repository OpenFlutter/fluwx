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
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/src/share/share_models.dart';
import 'package:fluwx/src/wechat_enums.dart';

void main() {
  test("test create WeChatShareImageModel with thumbnail", () {
    var image = WeChatImage.network("http://openflutter.dev/fluwx.png");
    var thumbnail = WeChatImage.network("http://openflutter.dev/fluwx.png");
    var model = WeChatShareImageModel(image,
        scene: WeChatScene.FAVORITE, thumbnail: thumbnail);
    expect(model.source, image);
    expect(model.scene, WeChatScene.FAVORITE);
    expect(model.thumbnail, thumbnail);
  });

  test("test create WeChatShareImageModel without thumbnail", () {
    var image = WeChatImage.network("http://openflutter.dev/fluwx.png");
    var model = WeChatShareImageModel(image, scene: WeChatScene.FAVORITE);
    expect(model.source, image);
    expect(model.scene, WeChatScene.FAVORITE);
    expect(model.thumbnail, image);
  });

  test("test WeChatShareImageModel toMap", () {
    var image = WeChatImage.network("http://openflutter.dev/fluwx.png");
    var thumbnail = WeChatImage.network("http://openflutter.dev/fluwx.png");
    var map = WeChatShareImageModel(image,
            scene: WeChatScene.FAVORITE, thumbnail: thumbnail)
        .toMap();
    assert(map["thumbnail"] != null);
    expect(map["thumbnail"]["source"], "http://openflutter.dev/fluwx.png");
  });
}
