## Fluwx ![pub package](https://img.shields.io/pub/v/fluwx.svg)

![logo](./arts/fluwx_logo.png)

[中文请移步此处](./README_CN.md)

`Fluwx` makes easier using WeChatSDK on Flutter.
QQ Group：892398530。

## Before
 Before using`Fluwx`,I highly recommond you read this [article](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1)，
 this'll help you。

### What does Fluwx support?
* Share Text.
* Share WebPage.
* Share Image.
* Share Music.
* Share Video.
* Share MiniProgram.
* Send Auth(Login).
* Pay.
* Launch Mini-Program.

## Libraries Used In Fluwx
  For Android,`kotlin-1.3.0` is included:
   ```gradle
    api 'com.tencent.mm.opensdk:wechat-sdk-android-with-mta:5.1.4'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.0.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.0.0'
    implementation 'top.zibin:Luban:1.1.8'
    implementation 'com.squareup.okhttp3:okhttp:3.11.0'
   ```


    Flutter 0.9.4 • channel beta • https://github.com/flutter/flutter.git<br>
    Framework • revision f37c235c32 (5 weeks ago) • 2018-09-25 17:45:40 -0400<br>
    Engine • revision 74625aed32<br>
    Tools • Dart 2.1.0-dev.5.0.flutter-a2eb050044<br>


  For iOS,*wechat-sdk-1.8.3*(WeChatPay included) is included.

## Register WeChatSDK via Fluwx
Before using`Fluwx`,you should init `FLuwx`：
 ```dart
    import 'package:fluwx/fluwx.dart' as fluwx;
    fluwx.register(appId:"wxd930ea5d5a258f4f");
 ```



> NOTE：Although we can register WXApi via Fluwx,but there's still some work you have to do on the particular platform.For example, add a URLSchema for iOS.

### More
* [Share](./doc/SHARE.md)。
* [Auth](./doc/SEND_AUTH.md)。
* [Payment](./doc/WXPay.md)。
* [Response](./doc/RESPONSE.md)。

### Other
* [Using Swift?](./doc/USING_SWIFT.md)
* [Having Questions?](./doc/QUESTIONS.md)
### Waiting
### Donate
![WeChatPay](./arts/wx.jpeg =300 * 300) ![AliPay](./arts/ali.jpeg)
## LICENSE


    Copyright 2018 OpenFlutter Project

    Licensed to the Apache Software Foundation (ASF) under one or more contributor
    license agreements.  See the NOTICE file distributed with this work for
    additional information regarding copyright ownership.  The ASF licenses this
    file to you under the Apache License, Version 2.0 (the "License"); you may not
    use this file except in compliance with the License.  You may obtain a copy of
    the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
    License for the specific language governing permissions and limitations under
    the License.
