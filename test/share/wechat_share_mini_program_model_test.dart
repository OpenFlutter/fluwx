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
  group("construct", () {
    test("non default values", () {
      var thumbnail =
          WeChatImage.network("http://openflutter.dev/fluwx.png");
      var model = WeChatShareMiniProgramModel(
          webPageUrl: "http://openflutter.dev",
          miniProgramType: WXMiniProgramType.PREVIEW,
          withShareTicket: true,
          thumbnail: thumbnail,
          userName: "userName",
          path: "path",
          hdImagePath: thumbnail);
      expect(model.webPageUrl, "http://openflutter.dev");
      expect(model.miniProgramType, WXMiniProgramType.PREVIEW);
      expect(model.thumbnail, thumbnail);
      expect(model.hdImagePath, thumbnail);
      expect(model.path, "path");
      expect(model.userName, "userName");
    });

    test("default values", () {
      var model = WeChatShareMiniProgramModel(
          webPageUrl: "http://openflutter.dev", userName: "userName");
      expect(model.webPageUrl, "http://openflutter.dev");
      expect(model.miniProgramType, WXMiniProgramType.RELEASE);
      expect(model.thumbnail, null);
      expect(model.path, "/");
      expect(model.userName, "userName");
    });
  });

  group("toMap", () {
    test("with thumbnail", () {
      var thumbnail =
          WeChatImage.network("http://openflutter.dev/fluwx.png");
      var map = WeChatShareMiniProgramModel(
              webPageUrl: "http://openflutter.dev",
              miniProgramType: WXMiniProgramType.PREVIEW,
              withShareTicket: true,
              thumbnail: thumbnail,
              userName: "userName",
              path: "path")
          .toMap();
      expect(map["webPageUrl"], "http://openflutter.dev");
      expect(map["miniProgramType"], 2);
      expect(map["thumbnail"]["source"], "http://openflutter.dev/fluwx.png");
      expect(map["path"], "path");
      expect(map["userName"], "userName");
    });

    test("without thumbnail", () {
      var map = WeChatShareMiniProgramModel(
              webPageUrl: "http://openflutter.dev",
              miniProgramType: WXMiniProgramType.PREVIEW,
              withShareTicket: true,
              userName: "userName",
              path: "path")
          .toMap();
      expect(map["webPageUrl"], "http://openflutter.dev");
      expect(map["miniProgramType"], 2);
      expect(map["thumbnail"], null);
      expect(map["path"], "path");
      expect(map["userName"], "userName");
    });
  });
}
