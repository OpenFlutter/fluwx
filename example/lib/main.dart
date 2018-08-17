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
                  WeChatShareWebPageModel(
                    webPage: "https://www.jianshu.com/",
                    title: "简书",

                  )
                    ).then((result){
                    print("--$result");
                },onError: (msg){
                      print(msg);
                });
              },
              child: new Text("share ")),
        ),
      ),
    );
  }
}
