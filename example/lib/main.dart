import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fluwx/main.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
//    initPlatformState();
    Fluwx.init("wxd930ea5d5a258f4f").then((_) {
      print("succes");
    }, onError: (value) {
      print("--->$value");
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
//      platformVersion = await Fluwx.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new FlatButton(
              onPressed: () {
                var fluwx = Fluwx();
                fluwx.share(WeChatShareImageModel(
                  image: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1534342262&di=450af299b06a8a46220bdbd53d04e1b8&src=http://www.qqzhi.com/uploadpic/2014-09-25/120045136.jpg",
                  transaction: "hehe",
                  title: "from dart",
                  scene: WeChatScene.SESSION
                ));
              },
              child: new Text("share text to wechat")),
        ),
      ),
    );
  }
}
