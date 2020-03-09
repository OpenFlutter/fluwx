# Fluwx
![pub package](https://img.shields.io/pub/v/fluwx.svg)
[![Build status](https://img.shields.io/cirrus/github/OpenFlutter/fluwx/master)](https://cirrus-ci.com/github/OpenFlutter/fluwx)
======

![logo](https://github.com/JarvanMo/ImagesStore/blob/master/fluwx/fluwx_logo.png)

## 什么是Fluwx
`Fluwx` 是一个[微信SDK](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Resource_Center_Homepage.html)插件，它允许开发者调用
[微信原生SDK ](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Resource_Center_Homepage.html).

> 加入我们的QQ群: 892398530。

## 能力

- 分享图片，文本，音乐，视频等。支持分享到会话，朋友圈以及收藏.
- 微信支付.
- 在微信登录时，获取Auth Code.
- 拉起小程序.
- 订阅消息.
- 打开微信.

## 准备

`Fluwx` 可以做很多工作但不是所有. 在集成之前，最好读一下[官方文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1).  
 然后你才知道怎么生成签名，怎么使用universal link以及怎么添加URL schema等.

> [收费视频教程点这里](https://study.163.com/course/introduction.htm?share=2&shareId=480000001896427&courseId=1209174838&_trace_c_p_k2_=e72467dc0df540579287a8ea996344a4)
>
## 安装

在`pubspec.yaml` 文件中添加`fluwx`依赖:

`Fluwx`，带支付:

```yaml
dependencies:
  fluwx: ^${latestVersion}
```
![pub package](https://img.shields.io/pub/v/fluwx.svg)

`Fluwx`，不带支付:

```yaml
dependencies:
  fluwx_no_pay: ^${latestVersion}
```

![pub package](https://img.shields.io/pub/v/fluwx_no_pay.svg)

> NOTE: 别忘记替换 ^${latestVersion} ！！！！

## 注册 WxAPI

通过 `fluwx` 注册WxApi.

```dart
registerWxApi(appId: "wxd930ea5d5a228f5f",universalLink: "https://your.univerallink.com/link/");
```

参数 `universalLink` 只在iOS上有用. 查看[文档](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html) 以便了解如何生成通用链接.  
 你也可以学习到怎么在iOS工程中添加URL schema，怎么添加`LSApplicationQueriesSchemes`。这很重要。

对于Android, 可以查看[本文](https://developers.weixin.qq.com/doc/oplatform/Downloads/Android_Resource.html)以便了解怎么获取app签名.
然后你需要知道release和debug时，app签名有什么区别。如果签名不对，你会得一个错误 `errCode = -1`.

## 能力文档

- [基础知识](./doc/BASIC_KNOWLEDGE_CN.md)
- [分享](./doc/SHARE_CN.md)
- [支付](./doc/PAYMENT_CN.md)
- [登录](./doc/AUTH_CN.md)

对于更多功能，可以查看源码。

## QA

[这些问题可能对你有帮助](./doc/QA_CN.md)

## 捐助
开源不易，请作者喝杯咖啡。

<img src="https://github.com/JarvanMo/ImagesStore/blob/master/common/wx.jpeg" height="300">  <img src="https://github.com/JarvanMo/ImagesStore/blob/master/common/ali.jpeg" height="300">

## 关注公众号
![subscribe](https://github.com/JarvanMo/ImagesStore/blob/master/fluwx/wx_subscription.png)

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





