import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class LaunchMiniProgramPage extends StatefulWidget {
  @override
  _LaunchMiniProgramPageState createState() => _LaunchMiniProgramPageState();
}

class _LaunchMiniProgramPageState extends State<LaunchMiniProgramPage> {
  String _result = "无";

  @override
  void initState() {
    super.initState();
    weChatResponseEventHandler.listen((res) {
      if (res is WeChatLaunchMiniProgramResponse) {
        if (mounted) {
          setState(() {
            _result = "isSuccessful:${res.isSuccessful}";
          });
        }
      }
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
        title: const Text("Launch MiniProgrom"),
      ),
      body: Column(
        children: <Widget>[
          OutlineButton(
            onPressed: () {
              launchWeChatMiniProgram(username: "gh_d43f693ca31f");
            },
            child: const Text("Launch MiniProgrom"),
          ),
          const Text("响应结果;"),
          Text(_result)
        ],
      ),
    );
  }
}
