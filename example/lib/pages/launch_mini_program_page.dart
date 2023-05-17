import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class LaunchMiniProgramPage extends StatefulWidget {
  const LaunchMiniProgramPage({Key? key}) : super(key: key);

  @override
  State<LaunchMiniProgramPage> createState() => _LaunchMiniProgramPageState();
}

class _LaunchMiniProgramPageState extends State<LaunchMiniProgramPage> {
  String? _result = '无';
  final Fluwx fluwx = Fluwx();
  late Function(WeChatResponse) responseListener;

  @override
  void dispose() {
    super.dispose();
    _result = null;
    fluwx.removeSubscriber(responseListener);
  }

  @override
  void initState() {
    super.initState();
    responseListener = (response) {
      if (response is WeChatLaunchMiniProgramResponse) {
        if (mounted) {
          setState(() {
            _result = 'isSuccessful:${response.isSuccessful}';
          });
        }
      }
    };

    fluwx.addSubscriber(responseListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launch MiniProgrom'),
      ),
      body: Column(
        children: <Widget>[
          OutlinedButton(
            onPressed: () {
              fluwx.open(target: MiniProgram(username: 'gh_d43f693ca31f'));
            },
            child: const Text('Launch MiniProgrom'),
          ),
          const Text('响应结果;'),
          Text('$_result')
        ],
      ),
    );
  }
}
