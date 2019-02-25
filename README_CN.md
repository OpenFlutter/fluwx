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
* 打开小程序。
* 一次性订阅消息。



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
* [打开小程序](./doc/LAUNCH_MINI_PROGRAM_CN.md)。
* [一次性订阅消息](./doc/SUBSCRIBE_MESSAGE_CN.md)。
* [微信回调](./doc/RESPONSE_CN.md)。

### 其他
* [使用Swift?](./doc/USING_SWIFT_CN.md)
* [有问题?](./doc/QUESTIONS_CN.md)

### 更多功能敬请请期待

### 捐助
请作者喝杯咖啡。

<img src="./arts/wx.jpeg" height="300">  <img src="./arts/ali.jpeg" height="300">

### 欢迎关注公众号
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
