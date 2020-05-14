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
import 'package:fluwx/src/wechat_file.dart';

void main() {

  test("test  WeChatImage.fromNetwork", () {
    var withSuffixImage =
        WeChatImage.network("http://image.openflutter.dev/fluwx.png");
    expect(withSuffixImage.source, "http://image.openflutter.dev/fluwx.png");
    expect(withSuffixImage.suffix, ".png");
    expect(FileSchema.NETWORK, withSuffixImage.schema);

    var withNoSuffixNoUrlSuffixImage =
        WeChatImage.network("http://image.openflutter.dev/fluwx");
    expect("http://image.openflutter.dev/fluwx",
        withNoSuffixNoUrlSuffixImage.source);
    expect(withNoSuffixNoUrlSuffixImage.suffix, ".jpeg");
    expect(FileSchema.NETWORK, withSuffixImage.schema);

    var withSpecifiedSuffixImage = WeChatImage.network(
        "http://image.openflutter.dev/fluwx.jpeg",
        suffix: ".png");
    expect(withSpecifiedSuffixImage.source, "http://image.openflutter.dev/fluwx.jpeg");
    expect(withSpecifiedSuffixImage.suffix, ".png");
    expect(withSpecifiedSuffixImage.schema, FileSchema.NETWORK);
  });
}
