import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluwx/fluwx.dart';
import 'package:fluwx_example/share_video_page.dart';
import 'share_music.dart';
import 'share_web_page.dart';
import 'share_image_page.dart';
import 'share_text_image.dart';

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
        "shareImage":(context) => ShareImagePage(),
        "shareWebPage":(context) => ShareWebPagePage(),
        "shareMusic":(context) => ShareMusicPage(),
        "shareVideo":(context) => ShareVideoPage(),
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
    return new Column(
      children: <Widget>[
        new OutlineButton(onPressed: () {
          Navigator.of(context).pushNamed("shareText");
        }, child: const Text("share text")),
        new OutlineButton(onPressed: () {
          Navigator.of(context).pushNamed("shareImage");
        }, child: const Text("share image")),
        new OutlineButton(onPressed: () {
          Navigator.of(context).pushNamed("shareWebPage");

        }, child: const Text("share webpage")),
        new OutlineButton(onPressed: () {
          Navigator.of(context).pushNamed("shareMusic");

        }, child: const Text("share music")),
      ],
    );
  }
}
