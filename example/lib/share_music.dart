import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class ShareMusicPage extends StatefulWidget {
  @override
  _ShareMusicPageState createState() => _ShareMusicPageState();
}

class _ShareMusicPageState extends State<ShareMusicPage> {
  String _musicUrl =
      "http://staff2.ustc.edu.cn/~wdw/softdown/index.asp/0042515_05.ANDY.mp3";
  String _musicLowBandUrl = "http://www.qq.com";
  String _title = "Beyond";
  String _description = "A Popular Rock Band From China";
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
        title: const Text("ShareMusicPage"),
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
                  text:
                      "http://staff2.ustc.edu.cn/~wdw/softdown/index.asp/0042515_05.ANDY.mp3"),
              onChanged: (str) {
                _musicUrl = str;
              },
              decoration: InputDecoration(labelText: "music url"),
            ),
            new TextField(
              controller: TextEditingController(text: "http://www.qq.com"),
              onChanged: (str) {
                _musicLowBandUrl = str;
              },
              decoration: InputDecoration(labelText: "music low band url"),
            ),
            new TextField(
              controller: TextEditingController(text: "Beyond"),
              onChanged: (str) {
                _title = str;
              },
              decoration: InputDecoration(labelText: "title"),
            ),
            new TextField(
              controller:
                  TextEditingController(text: "A Popular Rock Band From China"),
              onChanged: (str) {
                _description = str;
              },
              decoration: InputDecoration(labelText: "description"),
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
    var model = fluwx.WeChatShareMusicModel(
        title: _title,
        description: _description,
        transaction: "music",
        musicUrl: _musicUrl,
        scene: scene,
        musicLowBandUrl: _musicLowBandUrl,
        thumbnail: _thumnail);

    fluwx.share(model);
  }

  void handleRadioValueChanged(fluwx.WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}
