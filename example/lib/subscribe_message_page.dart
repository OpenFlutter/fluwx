import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SubscribeMessagePage extends StatefulWidget {
  @override
  _SubscribeMessagePageState createState() => _SubscribeMessagePageState();
}

/// see wechat [document](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1500434436_aWfqW&token=&lang=zh_CN)
class _SubscribeMessagePageState extends State<SubscribeMessagePage> {
  TextEditingController appId =
      TextEditingController(text: "wx316f9c82e99ac105");
  TextEditingController scene = TextEditingController(text: "1");
  TextEditingController templateId = TextEditingController(
      text: "cm_vM2k3IjHcYbkGUeAfL6Fja_7Pgv4Hx_q4tA253Ss");
  TextEditingController reserved = TextEditingController(text: "123");

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
    scene.dispose();
    templateId.dispose();
    reserved.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SubscribeMessagePage'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildTextField(title: "appId", textEditController: appId),
            _buildTextField(title: "scene", textEditController: scene),
            _buildTextField(
                title: "templateId", textEditController: templateId),
            _buildTextField(title: "reserved", textEditController: reserved),
            FlatButton(
              child: Text('request once subscribe message'),
              onPressed: _requestSubMsg,
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

  void _requestSubMsg() {
    fluwx.subscribeMsg(
      appId: appId.text,
      scene: int.tryParse(scene.text) ?? 1,
      templateId: templateId.text,
      reserved: reserved.text,
    );
  }
}
