import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SendAuthPage extends StatefulWidget {
  @override
  _SendAuthPageState createState() => _SendAuthPageState();
}

class _SendAuthPageState extends State<SendAuthPage> {
  String _result = "无";

  @override
  void initState() {
    super.initState();
    fluwx.responseFromAuth.listen((data) {
      setState(() {
        _result = "${data.errCode}";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _result = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Auth"),
      ),
      body: Column(
        children: <Widget>[
          OutlineButton(
            onPressed: () {
              fluwx
                  .sendAuth(
                      scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
                  .then((data) {});
            },
            child: const Text("send auth"),
          ),
          const Text("响应结果;"),
          Text(_result)
        ],
      ),
    );
  }
}
