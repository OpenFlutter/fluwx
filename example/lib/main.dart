import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

import 'pay_page.dart';
import 'send_auth.dart';
import 'share_image_page.dart';
import 'share_mini_program.dart';
import 'share_music.dart';
import 'share_text_image.dart';
import 'share_video_page.dart';
import 'share_web_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Fluwx.registerApp(RegisterModel(appId: "wxd930ea5d5a258f4f"));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: <String, WidgetBuilder>{
        "shareText": (context) => ShareTextPage(),
        "shareImage": (context) => ShareImagePage(),
        "shareWebPage": (context) => ShareWebPagePage(),
        "shareMusic": (context) => ShareMusicPage(),
        "shareVideo": (context) => ShareVideoPage(),
        "sendAuth": (context) => SendAuthPage(),
        "shareMiniProgram": (context) => ShareMiniProgramPage(),
        "pay": (context) => PayPage(),
      },
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ShareSelectorPage()),
    );
  }
}

class ShareSelectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: new ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("shareText");
                },
                child: const Text("share text")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("shareImage");
                },
                child: const Text("share image")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("shareWebPage");
                },
                child: const Text("share webpage")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("shareMusic");
                },
                child: const Text("share music")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("shareVideo");
                },
                child: const Text("share video")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("shareMiniProgram");
                },
                child: const Text("share mini program")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("sendAuth");
                },
                child: const Text("send auth")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("pay");
                },
                child: const Text("pay")),
          ),
        ],
      ),
    );
  }
}
