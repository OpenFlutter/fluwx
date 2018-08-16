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
    Fluwx.init("wxd930ea5d5a258f4f").then((result) {
      print("succes-->$result");
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
//                thumbnail: 'http://b.hiphotos.baidu.com/image/h%3D300/sign=4bfc640817d5ad6eb5f962eab1c939a3/8718367adab44aedb794e128bf1c8701a08bfb20.jpg',
                fluwx.share(
                    WeChatShareImageModel(
                    image: 'http://a.hiphotos.baidu.com/image/h%3D300/sign=91a426229082d158a4825fb1b00819d5/0824ab18972bd4077557733177899e510eb3096d.jpg',
                    thumbnail:'http://a.hiphotos.baidu.com/image/h%3D300/sign=91a426229082d158a4825fb1b00819d5/0824ab18972bd4077557733177899e510eb3096d.jpg',
                    transaction:
                        'http://b.hiphotos.baidu.com/image/h%3D300/sign=4bfc640817d5ad6eb5f962eab1c939a3/8718367adab44aedb794e128bf1c8701a08bfb20.jpg',
                    scene: WeChatScene.SESSION));
              },
              child: new Text("share text to wechat")),
        ),
      ),
    );
  }
}
