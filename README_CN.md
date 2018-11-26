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
   Android部分使用到了`kotlin-1.3.0`。以下是Android部分所涉及到的技术:
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
   
   
   在iOS上使用了*wechat-sdk-1.8.3*(包含支付)。


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

### 捐助
<img src="./arts/wx.jpeg" height="300">  <img src="./arts/ali.jpeg" height="300">

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
