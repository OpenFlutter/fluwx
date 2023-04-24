import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class SendAuthPage extends StatefulWidget {
  const SendAuthPage({Key? key}) : super(key: key);

  @override
  State<SendAuthPage> createState() => _SendAuthPageState();
}

class _SendAuthPageState extends State<SendAuthPage> {
  String? _result = '无';
  Fluwx fluwx = Fluwx();

  @override
  void initState() {
    super.initState();
    fluwx.subscribeResponse((response) {
      if (response is WeChatAuthResponse) {
        setState(() {
          _result = 'state :${response.state} \n code:${response.code}';
        });
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
      appBar: AppBar(title: const Text('Send Auth')),
      body: Column(
        children: <Widget>[
          OutlinedButton(
            onPressed: () {
              fluwx
                  .authBy(
                      which: NormalAuth(
                    scope: 'snsapi_userinfo',
                    state: 'wechat_sdk_demo_test',
                  ))
                  .then((data) {});
            },
            child: const Text('send auth'),
          ),
          const Text('响应结果;'),
          Text('$_result')
        ],
      ),
    );
  }
}
