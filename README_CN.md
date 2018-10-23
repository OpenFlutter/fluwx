## FLuwx  ![pub package](https://img.shields.io/pub/v/fluwx.svg)

![logo](./arts/fluwx_logo.png)

适用于Flutter的微信SDK，方便快捷。
QQ群：892398530。


## 使用需知
 使用`Fluwx`之前，强烈建议先阅读[微信SDK官方文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1)，
 这有助于你使用`Fluwx`。

### 目前功能
* 文本分享。
* 网站分享。
* 图片分享。
* 音乐分享。
* 视频分享。
* 小程序分享。
* 发送Auth认证（登录）。
* 支付。
* 拉起小程序。

## 技术参数
   Android部分使用到了`kotlin-1.2.71`。以下是Android部分所涉及到的技术:
   ```gradle
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    api 'com.tencent.mm.opensdk:wechat-sdk-android-with-mta:5.1.4'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:0.30.2'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:0.30.2'
    implementation 'top.zibin:Luban:1.1.8'
    implementation 'com.squareup.okhttp3:okhttp:3.11.0'

   ```

   Flutter版本信息<br>
   Flutter 0.8.2 • channel beta • https://github.com/flutter/flutter.git<br>
   Framework • revision 5ab9e70727 (11 days ago) • 2018-09-07 12:33:05 -0700<br>
   Engine • revision 58a1894a1c<br>
   Tools • Dart 2.1.0-dev.3.1.flutter-760a9690c2<br>
   
   
   


## 初始化
使用`Fluwx`前，需要进行初始化操作：
 ```dart
     import 'package:fluwx/fluwx.dart' as fluwx;
     fluwx.register(appId:"wxd930ea5d5a258f4f");
 ```


> 注意：尽管可以通过Fluwx完成微信注册，但一些操作依然需要在对应平台进行设置，如配置iOS的URLSchema等。

### 传送门
* [分享](./doc/SHARE_CN.md)。
* [Auth](./doc/SEND_AUTH_CN.md)。
* [支付](./doc/WXPay_CN.md)。
* [回调](./doc/RESPONSE_CN.md)。

### 其他
* [使用Swift?](./doc/USING_SWIFT_CN.md)
* [有问题?](./doc/QUESTIONS_CN.md)

### 更多功能敬请请期待

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
