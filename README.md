![logo](./arts/fluwx_logo.png)

[中文请移步此处](./README_CN.md)

`Fluwx` makes easier using WeChatSDK on Flutter.


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

## Tech Used In Fluwx
  For Android,`kotlin-1.2.60` is included:
   ```gradle
    api 'com.tencent.mm.opensdk:wechat-sdk-android-with-mta:5.1.4'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:0.24.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:0.24.0'
    implementation 'top.zibin:Luban:1.1.8'
    implementation 'com.squareup.okhttp3:okhttp:3.11.0'
   ```
   For iOS:
   ```podspec
    s.dependency 'WechatOpenSDK','~> 1.8.2'
   ```
   For Flutter：<br>
   Flutter 0.8.2 • channel beta • https://github.com/flutter/flutter.git<br>
   Framework • revision 5ab9e70727 (11 days ago) • 2018-09-07 12:33:05 -0700<br>
   Engine • revision 58a1894a1c<br>
   Tools • Dart 2.1.0-dev.3.1.flutter-760a9690c2<br>

## Import
add the following in your `pubspec.yaml` file:
```yaml
dependencies:
  fluwx: ^0.1.6
```


## Init Fluwx
Before using`Fluwx`,you should init `FLuwx`：
 ```dart
 Fluwx.registerApp(RegisterModel(appId: "your app id", doOnAndroid: true, doOnIOS: true));
 ```
 - `appId`：the appId you applied from WeChat.
 - `doOnAndroid`:whether init for Android.
 - `doOnIOS`:whether init for iOS
 Each param isn't necessary.However,if `appId`is blank, or `doOnAndroid: false`, or `doOnIOS: false`，you must register your `WXApi` on the particular platform in order to ensure  `Fluwx` can work.
 After tha，add the following code before using `Fluwx` on the particular platform:
 For Android：
 ```kotlin
 FluwxShareHandler.setWXApi(wxapi)
 ```
 For iOS:
 ```objective-c
isWeChatRegistered = YES;
 ```

> NOTE：Although we can register WXApi via Fluwx,but there's still some work you have to do on the particular platform.For example, creat a `WXEntryActivity` for android and add a URLSchema for iOS. 

### More
* [Share](./doc/SHARE.md)。
* [Auth](./doc/SEND_AUTH.md)。
* [Payment](./doc/WXPay.md)。
* [Response](./doc/RESPONSE.md)。


### Waiting 

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
