# Fluwx

[![pub package](https://img.shields.io/pub/v/fluwx.svg)](https://pub.dev/packages/fluwx)
![Build status](https://github.com/OpenFlutter/fluwx/actions/workflows/build_test.yml/badge.svg)
[![GitHub stars](https://img.shields.io/github/stars/OpenFlutter/fluwx)](https://github.com/OpenFlutter/fluwx/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/OpenFlutter/fluwx)](https://github.com/OpenFlutter/fluwx/network)
[![GitHub license](https://img.shields.io/github/license/OpenFlutter/fluwx)](https://github.com/OpenFlutter/fluwx/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/OpenFlutter/fluwx)](https://github.com/OpenFlutter/fluwx/issues)
<a target="_blank" href="https://qm.qq.com/q/TJ29rkzywM"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="OpenFlutter" title="OpenFlutter"></a>

---

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
- Open Customer Service

## Preparation

[Migrate to V4 now](./doc/MIGRATE_TO_V4_CN.md)

> Breaking changes ：*Fluwx* won't request permission(WRITE_EXTERNAL_STORAGE) since 4.5.0. That means you will need to handle permission when sharing images, if FileProvider is not supported.

`Fluwx` is good but not God. You'd better read [official documents](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Resource_Center_Homepage.html) before
integrating `Fluwx`. Then you'll understand how to generate Android signature, what's universal link for iOS, how to add URL schema for iOS and so on.

## Install

Add the `fluwx` package (with payment feature by default) in your `pubspec.yaml` file:

`fluwx` with pay:

```yaml
dependencies:
  fluwx: ^${latestVersion}
```

![pub package](https://img.shields.io/pub/v/fluwx.svg)

> [!WARNING]
> Never forget to replace ^${latestVersion} with an actual version!<br />
> (See the above version, or go to [versions](https://pub.dev/packages/fluwx/versions) on pub.dev)

> [!NOTE]
> `fluwx` without pay:<br/>
> Developers who need to exclude payment for iOS can set `no_pay: true` in the `fluwx` section of `pubspec.yaml`.<br/>
> See the example: [example/pubspec.yaml](./example/pubspec.yaml#L19)<br/>

## Configurations

`Fluwx` enables multiple configurations in the section `fluwx` of `pubspec.yaml` from v4, you can reference [pubspec.yaml](./example/pubspec.yaml#L10)
for more details.

> For iOS, some configurations, such as url_scheme，universal_link, LSApplicationQueriesSchemes, can be configured by `fluwx`,
> what you need to do is to fill configurations in `pubspec.yaml`

- app_id. Recommend. It'll be used to generate scheme on iOS。This is not used to init WeChat SDK so you still need to call `fluwx.registerApi` manually.
- debug_logging. Optional. Enable logs by setting it `true`.
- flutter_activity. Optional. This is usually used by cold boot from WeChat on Android. `Fluwx` will try to launch launcher activity if not set.
- universal_link. Recommend for iOS. It'll be used to generate universal link on your projects.
- scene_delegate. Optional. Use `AppDelegate` or `SceneDelegate`. See [official documents](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html) for more details.

- For iOS
 If you are failing `cannot load such file -- plist` on iOS, please do the following steps:

```shell
# step.1 install missing dependencies
sudo gem install plist
# step.2 enter iOS folder(example/ios/,ios/)
cd example/ios/
# step.3 execute
pod install
```

- On OpenHarmony, to check if WeChat is installed, add the following to the module.json5 in your project

```json5
{
  "module": {
    "querySchemes": [
      "weixin"
    ],
  }
}
```

> HarmonyOS Debugging Notice: Do not use the IDE's automatic signing. You must manually apply for a debug certificate for signing and debugging.

## Register WxAPI

Register your app via `fluwx` if necessary.

```dart
Fluwx fluwx = Fluwx();
final success = fluwx.registerApi(appId: "wxd930ea5d5a228f5f",universalLink: "https://your.univerallink.com/link/");
print("register API success: $success");
```
### iOS
The parameter `universalLink` only works with iOS. You can read [this document](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html) to learn
how to create universalLink and what additional configuration is needed on iOS. In what follows is a summary: 

1. A valid iOS universal link for this app is needed. 

2. Make sure the app has the entitlement Associated domains enabled

3. Add or modify `LSApplicationQueriesSchemes` in Info.plist in your iOS project. This is essential. The following strings should be added: `weixin`, `wechat`, `weixinULAPI` and `weixinURLParamsAPI`.

4. Add or modify `CFBundleURLTypes` in Info.plist in your iOS project. Add a URL type with name `weixin` and role `editor`. Put your WeChat App ID in URL Schemes. 
Example how this looks like in Info.plist after modifying via XCode:
```xml
<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>weixin</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>wx123456789</string>
			</array>
		</dict>
	</array>
```


### Android
Make sure the MD5 fingerprint of the signature of your app 
is registered at WeChat. You can extract this signature from your `keystore` using Java's keytool. 

In debug mode your app is signed with a debug key from the development machine which will not be recognized by WeChat and you'll get `errCode = -1`. If you want to test in debug mode you will have to modify your debug key 

You can read more about it on [this page](https://developers.weixin.qq.com/doc/oplatform/Downloads/Android_Resource.html).


It's better to register your API as early as possible.

## Capability Document

- [Basic knowledge](./doc/BASIC_KNOWLEDGE.md)
- [Share](./doc/SHARE.md)
- [Payment](./doc/PAYMENT.md)
- [Auth](./doc/AUTH.md)
- [Launch app from h5](./doc/LAUNCH_APP_FROM_H5.md)
- [Open Customer Service](/doc/Customer_Service.md)

For more capabilities, you can read the public functions of `fluwx`.

## QA

[These questions maybe help](./doc/QA_CN.md)

## Donate

Buy the writer a cup of coffee。

<img src="https://gitee.com/OpenFlutter/resoures-repository/raw/master/common/wx.jpeg" height="300">  <img src="https://gitee.com/OpenFlutter/resoures-repository/raw/master/common/ali.jpeg" height="300">

## Subscribe Us On WeChat

![subscribe](https://gitee.com/OpenFlutter/resoures-repository/raw/master/fluwx/wx_subscription.png)

## Star history

![stars](https://starchart.cc/OpenFlutter/fluwx.svg)

## LICENSE

    Copyright 2023 OpenFlutter Project

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
