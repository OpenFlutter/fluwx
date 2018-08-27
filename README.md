![logo](/arts/fluwx_logo.png)

适用于Flutter的微信SDK，方便快捷。


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
* 发送Auth认证。

## 技术参数
   Android部分使用到了`kotlin-1.2.60`。以下是Android部分所涉及到的技术:
   ```gradle
    implementation 'com.tencent.mm.opensdk:wechat-sdk-android-with-mta:5.1.4'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:0.24.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:0.24.0'
    implementation 'top.zibin:Luban:1.1.8'
    implementation 'com.squareup.okhttp3:okhttp:3.11.0'
   ```
   iOS部分涉及到的技术：
   ```podspec
    s.dependency 'WechatOpenSDK','~> 1.8.2'
   ```
## 引入
在`pubspec.yaml`文件中添加如下代码：
```yaml
dependencies:
  fluwx: ^0.0.3
```


## 初始化
使用`Fluwx`前，需要进行初始化操作：
 ```dart
 Fluwx.registerApp(RegisterModel(appId: "your app id", doOnAndroid: true, doOnIOS: true));
 ```
 - `appId`：在微信平台申请的appId。
 - `doOnAndroid`:是否在android平台上执行此操作。
 - `doOnIOS`:是否在平台上执行此操作。</br>
 每一个字段都是非必须的，但是如果不传`appId`或`doOnAndroid: false`或者`doOnIOS: false`，在使用前请务必手动注册`WXApi`，以保证
 `Fluwx`正常工作。
 注册完成后，请在使用`Fluwx`前在对应平台添加如下代码：
 Android上：
 ```kotlin
 FluwxShareHandler.setWXApi(wxapi)
 ```
 iOS上：
 ```objective-c
isWeChatRegistered = YES;
 ```

> 注意：尽管可以通过Fluwx完成微信注册，但一些操作依然需要在对应平台进行设置，如配置iOS的URLSchema，Android上的WXEntryActivity等。

### 传送门
* [分享功能](docs/SHARE.md)。
* [Auth认证](docs/SEND_AUTH.md)。
* [支付](docs/WXPay.md)。
* [回调](docs/RESPONSE.md)。


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
