## Fluwx ![pub package](https://img.shields.io/pub/v/fluwx.svg)

![logo](./arts/fluwx_logo.png)

[中文请移步此处](./README_CN.md)

`Fluwx` makes easier using WeChatSDK on Flutter.
QQ Group：892398530。

## Before
 Before using`Fluwx`,read this [article](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1) first.


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
* Subscribe Message.


## Register WeChatSDK via Fluwx
Before using`Fluwx`,you should init `FLuwx`：
 ```dart
    import 'package:fluwx/fluwx.dart' as fluwx;
    fluwx.register(appId:"wxd930ea5d5a258f4f");
 ```



> NOTE：Although we can register WXApi via Fluwx,but there's still some work you have to do on the particular platform.For example, add a URLSchema for iOS.

### More
* [Share](./doc/SHARE.md)
* [Auth](./doc/SEND_AUTH.md)
* [Payment](./doc/WXPay.md)
* [Response](./doc/RESPONSE.md)
* [Launch Mini-Program](./doc/LAUNCH_MINI_PROGRAM.md)
* [Subscribe Message](./doc/SUBSCRIBE_MESSAGE.md)

### Other
* [Using Swift?](./doc/USING_SWIFT.md)
* [Having Questions?](./doc/QUESTIONS.md)
### Waiting
### Donate
Buy the writer a cup of coffee。

<img src="./arts/wx.jpeg" height="300">  <img src="./arts/ali.jpeg" height="300">

### Subscribe Us On WeChat
![subscribe](./arts/wx_subscription.png)

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
