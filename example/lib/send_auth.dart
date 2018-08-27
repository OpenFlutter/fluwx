import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class SendAuthPage extends StatefulWidget {
  @override
  _SendAuthPageState createState() => _SendAuthPageState();
}

class _SendAuthPageState extends State<SendAuthPage> {

  Fluwx _fluwx;
  String _result ="无";
  @override
  void initState() {
    super.initState();
    _fluwx = new Fluwx();
    _fluwx.response.listen((data){
      setState(() {
        _result = data.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Auth"),
      ),
      body: Column(
        children: <Widget>[
          OutlineButton(onPressed: (){
            _fluwx.sendAuth(new WeChatSendAuthModel(scope: "snsapi_userinfo",state: "wechat_sdk_demo_test"));
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
