## Fluwx ![pub package](https://img.shields.io/pub/v/fluwx.svg)

![logo](./arts/fluwx_logo.png)

[中文请移步此处](./README_CN.md)

`Fluwx` makes easier using WeChatSDK on Flutter.
QQ Group：892398530。

## Before
 Before using`Fluwx`,read [the official documents](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1) first.  
 This is very important because some configurations or details are not listed here.



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
* Auth By QRCode.
* Sign Auto-Deduct.
* Open WeChat App.

## Sample

[See sample here](./example)

[watch charged video here](https://study.163.com/course/introduction.htm?share=2&shareId=480000001896427&courseId=1209174838&_trace_c_p_k2_=e72467dc0df540579287a8ea996344a4)

[upgrade to 1.0.0 or above](./doc/QUESTIONS.md)

## Dependencies

Add the following dependencies in your `pubspec.yaml` file:

```yaml
dependencies:
  fluwx: ^${latestVersion}
```

> Latest version is ![pub package](https://img.shields.io/pub/v/fluwx.svg)

For using the snapshot:

```yaml
dependencies:
  fluwx:
    git:
      url: https://github.com/OpenFlutter/fluwx
```

## Register WeChatSDK via Fluwx

Before using`Fluwx`,you should init `FLuwx`：

 ```dart
    import 'package:fluwx/fluwx.dart' as fluwx;
    fluwx.register(appId:"wxd930ea5d5a258f4f",universalLink:"");
    
 ```
Developers must provide `universalLink` if you want register WeChat via fluwx, otherwise, ignore.


> NOTE：Although we can register WXApi via Fluwx,but there's still some work you have to do on the particular platform.For example, add  URLSchema or universal link for iOS. 
Please read the official documents for details.

### More
* [Share](./doc/SHARE.md)
* [Auth](./doc/SEND_AUTH.md)
* [Payment](./doc/WXPay.md)
* [Launch Mini-Program](./doc/LAUNCH_MINI_PROGRAM.md)
* [Subscribe Message](./doc/SUBSCRIBE_MESSAGE.md)
* [Auth By QRCode](./doc/AUTH_BY_QR_CODE.md)
* [Sign Auto-Deduct](./doc/AUTO_DEDUCT.md)
* [Receive Response Or Callback From WeChat](./doc/RESPONSE.md)

### Other
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
