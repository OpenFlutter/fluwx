# Fluwx
![pub package](https://img.shields.io/pub/v/fluwx.svg)
![Build status](https://github.com/OpenFlutter/fluwx/actions/workflows/build_test.yml/badge.svg)
======

![logo](https://gitee.com/OpenFlutter/resoures-repository/raw/master/fluwx/fluwx_logo.png)

[中文请移步此处](./README_CN.md)

## What's Fluwx
`Fluwx` is flutter plugin for [WeChatSDK](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Resource_Center_Homepage.html) which allows developers to call  
[WeChatSDK](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Resource_Center_Homepage.html) native APIs.


> Join QQ Group now: 1003811176

![QQGroup](https://gitee.com/OpenFlutter/resoures-repository/raw/master/common/flutter.png)

## Capability

- Share images, texts, music and so on to WeChat, including session, favorite and timeline.
- Payment with WeChat.
- Get auth code before you login in with WeChat.
- Launch mini program in WeChat.
- Subscribe Message.
- Just open WeChat app.
- Launch app From wechat link.

## Preparation

[Migrate to V4 now](./doc/MIGRATE_TO_V4_CN.md)

`Fluwx` is good but not God. You'd better read [official documents](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1) before
integrating `Fluwx`. Then you'll understand how to generate Android signature, what's universal link for iOS, how to add URL schema for iOS and so on.

[Watch Charged Video](https://study.163.com/course/introduction.htm?share=2&shareId=480000001896427&courseId=1209174838&_trace_c_p_k2_=e72467dc0df540579287a8ea996344a4)

## Install

Add the following dependencies in your `pubspec.yaml` file:

`Fluwx` with pay:

```yaml
dependencies:
  fluwx: ^${latestVersion}
```
![pub package](https://img.shields.io/pub/v/fluwx.svg)

`Fluwx` without pay:

> Developers who need to exclude payment for iOS can enable `no_pay` in [pubspec.yaml](./example/pubspec.yaml).


> NOTE: Never forget to replace ^${latestVersion} with actual version.

## Configurations

`Fluwx` enables multiple configurations in the section `fluwx` of `pubspec.yaml` from v4, you can reference [pubspec.yaml](./example/pubspec.yaml)
for more details.

> For iOS, some configurations, such as url_scheme，universal_link, LSApplicationQueriesSchemes, can be configured by `fluwx`,
> what you need to do is to fill configurations in `pubspec.yaml`

- app_id. Optional but recommend. It'll be used to generate scheme on iOS and register WxApi on Android side if app is cold boot.
- debug_logging. Optional. Enable logs by setting it `true`.
- flutter_activity. Optional. This is usually used by cold boot from WeChat on Android. `Fluwx` will try to launch launcher activity if not set.
- universal_link. Required for iOS. It'll be used to generate universal link on your projects.

> If you are failing `cannot load such file -- plist` on iOS, please run `sudo gem install plist` first.

## Register WxAPI

Register your app via `fluwx` if necessary.

```dart
Fluwx fluwx = Fluwx();
fluwx.registerApi(appId: "wxd930ea5d5a228f5f",universalLink: "https://your.univerallink.com/link/");
```
The param `universalLink` only works with iOS. You can read [this document](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html) to learn
how to create universalLink. You can also learn how to add URL schema, how to add `LSApplicationQueriesSchemes` in your iOS project. This is essential.

For Android, you shall know to how generate signature for your app in [this page](https://developers.weixin.qq.com/doc/oplatform/Downloads/Android_Resource.html).
And you have to understand the difference between debug signature and release signature. Once the signature is incorrect, then you'll get `errCode = -1`.

## Capability Document

- [Basic knowledge](./doc/BASIC_KNOWLEDGE.md)
- [Share](./doc/SHARE.md)
- [Payment](./doc/PAYMENT.md)
- [Auth](./doc/AUTH.md)
- [Launch app from h5](./doc/LAUNCH_APP_FROM_H5.md)

For more capabilities, you can read the public functions of `fluwx`.

## QA

[These questions maybe help](./doc/QA_CN.md)

## Donate
Buy the writer a cup of coffee。

<img src="https://gitee.com/OpenFlutter/resoures-repository/raw/master/common/wx.jpeg" height="300">  <img src="https://gitee.com/OpenFlutter/resoures-repository/raw/master/common/ali.jpeg" height="300">

## Subscribe Us On WeChat
![subscribe](https://gitee.com/OpenFlutter/resoures-repository/raw/master/fluwx/wx_subscription.png)

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





