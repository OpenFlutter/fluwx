import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class ShareWebPagePage extends StatefulWidget {
  @override
  ShareWebPagePageState createState() {
    return new ShareWebPagePageState();
  }
}

class ShareWebPagePageState extends State<ShareWebPagePage> {
  String _url = "share text from fluwx";
  String _title = "Fluwx";
  String _thumnail = "assets://images/logo.png";
  fluwx.WeChatScene scene = fluwx.WeChatScene.SESSION;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text("ShareWebPage"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: _share)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              controller: TextEditingController(
                  text: "https://github.com/JarvanMo/fluwx"),
              onChanged: (str) {
                _url = str;
              },
              decoration: InputDecoration(labelText: "web page"),
            ),
            new TextField(
              controller: TextEditingController(text: "Fluwx"),
              onChanged: (str) {
                _title = str;
              },
              decoration: InputDecoration(labelText: "thumbnail"),
            ),
            new TextField(
              controller:
                  TextEditingController(text: "assets://images/logo.png"),
              onChanged: (str) {
                _thumnail = str;
              },
              decoration: InputDecoration(labelText: "thumbnail"),
            ),
            new Row(
              children: <Widget>[
                const Text("分享至"),
                Row(
                  children: <Widget>[
                    new Radio<fluwx.WeChatScene>(
                        value: fluwx.WeChatScene.SESSION,
                        groupValue: scene,
                        onChanged: handleRadioValueChanged),
                    const Text("会话")
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Radio<fluwx.WeChatScene>(
                        value: fluwx.WeChatScene.TIMELINE,
                        groupValue: scene,
                        onChanged: handleRadioValueChanged),
                    const Text("朋友圈")
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Radio<fluwx.WeChatScene>(
                        value: fluwx.WeChatScene.FAVORITE,
                        groupValue: scene,
                        onChanged: handleRadioValueChanged),
                    const Text("收藏")
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _share() {
    var model = fluwx.WeChatShareWebPageModel(
        webPage: _url,
        title: _title,
        thumbnail: _thumnail,
        scene: scene,
        transaction: "hh");
    fluwx.share(model);
  }

  void handleRadioValueChanged(fluwx.WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}
