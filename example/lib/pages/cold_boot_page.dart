import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class ColdBootPage extends StatefulWidget {
  const ColdBootPage({Key? key}) : super(key: key);

  @override
  State<ColdBootPage> createState() => _ColdBootPageState();
}

class _ColdBootPageState extends State<ColdBootPage> {
  final Fluwx fluwx = Fluwx();
  late Function(WeChatResponse) responseListener;
  String _result = "";
  @override
  void dispose() {
    super.dispose();
    _result = "";
    fluwx.removeSubscriber(responseListener);
  }

  @override
  void initState() {
    super.initState();
    responseListener = (response) {
      if (response is WeChatShowMessageFromWXRequest ) {
        if (mounted) {
          setState(() {
            _result = 'message ${response.extMsg}';
          });
        }
      }else if(response is WeChatLaunchFromWXRequest){
        if (mounted) {
          setState(() {
            _result = 'message ${response.extMsg}';
          });
        }
      }
    };

    fluwx.addSubscriber(responseListener);

    fluwx.attemptToResumeMsgFromWx();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cold boot"),),
      body: Center(child: Text(_result)),
    );
  }
}
