## FLuwx  ![pub package](https://img.shields.io/pub/v/fluwx.svg)

![logo](./arts/fluwx_logo.png)

适用于Flutter的微信SDK，方便快捷。
QQ群：892398530。


## 使用需知
 使用`Fluwx`之前，强烈建议先阅读[微信SDK官方文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1)，
 这有助于你使用`Fluwx`。
 这很重要，因为有一些概念以及配置不会体现在本文档中。

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
* 二维码登录。
* 签约免密支付。
* 打开微信。

## 示例

[点此查看示例](./example)

[收费视频教程点这里](https://study.163.com/course/introduction.htm?share=2&shareId=480000001896427&courseId=1209174838&_trace_c_p_k2_=e72467dc0df540579287a8ea996344a4)

[升级到1.0.0或者更高](./doc/QUESTIONS_CN.md)

## 引入

在你的 `pubspec.yaml` 文件中添加如下依赖:

```yaml
dependencies:
  fluwx: ^${latestVersion}
```

> 最新版本为 ![pub package](https://img.shields.io/pub/v/fluwx.svg)

如果想用github上最新版本:

```yaml
dependencies:
  fluwx:
    git:
      url: https://github.com/OpenFlutter/fluwx
```

## 初始化
使用`Fluwx`前，需要进行初始化操作：
 ```dart
     import 'package:fluwx/fluwx.dart' as fluwx;
     fluwx.register(appId:"wxd930ea5d5a258f4f",universalLink:"https://your.univeral.link.com/placeholder/");
 ```
如果你想通过fluwx在iOS端注册微信，请务必提供 `universalLink` ，否则无视这句话.


> 注意：尽管可以通过Fluwx完成微信注册，但一些操作依然需要在对应平台进行设置，如配置iOS的*URLSchema,LSApplicationQueriesSchemes,universal link*等。

### 传送门
* [分享](./doc/SHARE_CN.md)。
* [Auth](./doc/SEND_AUTH_CN.md)。
* [支付](./doc/WXPay_CN.md)。
* [打开小程序](./doc/LAUNCH_MINI_PROGRAM_CN.md)。
* [一次性订阅消息](./doc/SUBSCRIBE_MESSAGE_CN.md)。。
* [二维码登录](./doc/AUTH_BY_QR_CODE_CN.md)。
* [签约免密支付](./doc/AUTO_DEDUCT_CN.md)。
* [接收微信响应](./doc/RESPONSE_CN.md)。

### Q&A
请先看文档，再看Q&A，再查看issue，自我排查错误，方便你我他。依然无法解决的问题可以加群提问。
* [常见问题Q&A](./doc/QUESTIONS_CN.md)


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
