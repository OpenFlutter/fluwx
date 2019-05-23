import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SignAutoDeductPage extends StatefulWidget {
  @override
  _SignAutoDeductPageState createState() => _SignAutoDeductPageState();
}

/// see wechat [document](https://pay.weixin.qq.com/wiki/doc/api/pap.php?chapter=18_5&index=2)
class _SignAutoDeductPageState extends State<SignAutoDeductPage> {
  TextEditingController appId =
      TextEditingController(text: "wx316f9c82e99ac105");
  TextEditingController mchId = TextEditingController(text: "");
  TextEditingController planId = TextEditingController(text: "");
  TextEditingController contractCode = TextEditingController(text: "");
  TextEditingController requestSerial = TextEditingController(text: "");
  TextEditingController contractDisplayAccount =
      TextEditingController(text: "");
  TextEditingController notifyUrl = TextEditingController(text: "");
  TextEditingController version = TextEditingController(text: "1.0");
  TextEditingController sign = TextEditingController(text: "");
  TextEditingController timestamp = TextEditingController(text: "");
  TextEditingController returnApp = TextEditingController(text: "3");

  @override
  void initState() {
    super.initState();
    fluwx.responseFromSubscribeMsg.listen((resp) {
      print("resp = $resp");
    });
  }

  @override
  void dispose() {
    appId.dispose();
    mchId.dispose();
    planId.dispose();
    contractCode.dispose();
    contractDisplayAccount.dispose();
    requestSerial.dispose();
    notifyUrl.dispose();
    version.dispose();
    sign.dispose();
    timestamp.dispose();
    returnApp.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SubscribeMessagePage'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _buildTextField(title: "appId", textEditController: appId),
            _buildTextField(title: "mchId", textEditController: mchId),
            _buildTextField(title: "planId", textEditController: planId),
            _buildTextField(
                title: "contractCode", textEditController: contractCode),
            _buildTextField(
                title: "requestSerial", textEditController: requestSerial),
            _buildTextField(
                title: "contractDisplayAccount",
                textEditController: contractDisplayAccount),
            _buildTextField(title: "notifyUrl", textEditController: notifyUrl),
            _buildTextField(title: "version", textEditController: version),
            _buildTextField(title: "sign", textEditController: sign),
            _buildTextField(title: "timestamp", textEditController: timestamp),
            _buildTextField(title: "returnApp", textEditController: returnApp),
            CupertinoButton(
              child: Text('request once sign auto-deduct message'),
              onPressed: _signAutoDeduct,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    String title,
    TextEditingController textEditController,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: title,
      ),
      controller: textEditController,
    );
  }

  void _signAutoDeduct() {
    fluwx.autoDeDuct(
        appId: appId.text ?? "",
        mchId: mchId.text ?? "",
        planId: planId.text ?? "",
        contractCode: contractCode.text ?? "",
        requestSerial: requestSerial.text ?? "",
        contractDisplayAccount: contractDisplayAccount.text ?? "",
        notifyUrl: notifyUrl.text ?? "",
        version: version.text ?? "",
        sign: sign.text ?? "",
        timestamp: timestamp.text ?? "",
        returnApp: '3');
  }
}
