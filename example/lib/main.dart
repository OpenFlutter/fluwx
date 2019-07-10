import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

import 'pay_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  _initFluwx() async {
    await fluwx.register(
        appId: "wxd930ea5d5a258f4f",
        doOnAndroid: true,
        doOnIOS: true,
        enableMTA: false);
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: <String, WidgetBuilder>{
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
                  Navigator.of(context).pushNamed("pay");
                },
                child: const Text("pay")),
          ),
        ],
      ),
    );
  }
}
