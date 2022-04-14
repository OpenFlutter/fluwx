import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

import 'pages/auth_by_qr_code_page.dart';
import 'pages/launch_mini_program_page.dart';
import 'pages/pay_page.dart';
import 'pages/send_auth_page.dart';
import 'pages/share_image_page.dart';
import 'pages/share_mini_program_page.dart';
import 'pages/share_music_page.dart';
import 'pages/share_text_page.dart';
import 'pages/share_video_page.dart';
import 'pages/share_web_page.dart';
import 'pages/sign_auto_deduct_page.dart';
import 'pages/subscribe_message_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  _initFluwx() async {
    await registerWxApi(
      appId: 'wxd930ea5d5a258f4f',
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: 'https://your.univerallink.com/link/',
    );
    var result = await isWeChatInstalled;
    print('is installed $result');
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        'shareText': (context) => ShareTextPage(),
        'shareImage': (context) => ShareImagePage(),
        'shareWebPage': (context) => ShareWebPagePage(),
        'shareMusic': (context) => ShareMusicPage(),
        'shareVideo': (context) => ShareVideoPage(),
        'sendAuth': (context) => SendAuthPage(),
        'shareMiniProgram': (context) => ShareMiniProgramPage(),
        'pay': (context) => PayPage(),
        'launchMiniProgram': (context) => LaunchMiniProgramPage(),
        'subscribeMessage': (ctx) => SubscribeMessagePage(),
        'AuthByQRCode': (ctx) => AuthByQRCodePage(),
        'AutoDeduct': (ctx) => SignAutoDeductPage(),
      },
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: ShareSelectorPage(),
      ),
    );
  }
}

class ShareSelectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                String? extMsg = await getExtMsg();
                print('extMsg:$extMsg\n');
              },
              child: const Text('Get ExtMessage'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                bool? success = await startLog(logLevel: WXLogLevel.NORMAL);
                print('startLog:$success\n');
              },
              child: const Text('start log'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                dynamic success = await stopLog();
                print('stopLog:$success\n');
              },
              child: const Text('stop log'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('shareText');
              },
              child: const Text('share text'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('shareImage');
              },
              child: const Text('share image'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('shareWebPage');
              },
              child: const Text('share webpage'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('shareMusic');
              },
              child: const Text('share music'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('shareVideo');
              },
              child: const Text('share video'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('shareMiniProgram');
              },
              child: const Text('share mini program'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('sendAuth');
              },
              child: const Text('send auth'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('pay');
              },
              child: const Text('pay'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('launchMiniProgram');
              },
              child: const Text('Launch MiniProgram'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('subscribeMessage');
              },
              child: const Text('SubscribeMessage'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('AuthByQRCode');
              },
              child: const Text('AuthByQRCode'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('AutoDeduct');
              },
              child: const Text('SignAuto-deduct'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                openWeChatApp();
              },
              child: const Text('Open WeChat App'),
            ),
          ),
        ],
      ),
    );
  }
}
