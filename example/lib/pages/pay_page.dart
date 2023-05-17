import 'dart:convert';
import 'dart:io' as H;

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final Fluwx fluwx = Fluwx();
  final String _url = 'https://wxpay.wxutil.com/pub_v2/app/app_pay.php';
  String _result = '无';
  late Function(WeChatResponse) responseListener;

  @override
  void dispose() {
    super.dispose();
    fluwx.removeSubscriber(responseListener);
  }

  @override
  void initState() {
    super.initState();
    responseListener = (response) {
      if (response is WeChatPaymentResponse) {
        setState(() {
          _result = 'pay :${response.isSuccessful}';
        });
      }
    };
    fluwx.addSubscriber(responseListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pay')),
      body: Column(
        children: <Widget>[
          OutlinedButton(
            onPressed: () async {
              var h = H.HttpClient();
              h.badCertificateCallback = (cert, String host, int port) {
                return true;
              };
              var request = await h.getUrl(Uri.parse(_url));
              var response = await request.close();
              var data = await const Utf8Decoder().bind(response).join();
              Map<String, dynamic> result = json.decode(data);
              debugPrint(result['appid']);
              debugPrint(result['timestamp']);
              fluwx
                  .pay(
                      which: Payment(
                appId: result['appid'].toString(),
                partnerId: result['partnerid'].toString(),
                prepayId: result['prepayid'].toString(),
                packageValue: result['package'].toString(),
                nonceStr: result['noncestr'].toString(),
                timestamp: result['timestamp'],
                sign: result['sign'].toString(),
              ));
            },
            child: const Text('pay'),
          ),
          const Text('响应结果;'),
          Text(_result)
        ],
      ),
    );
  }
}
