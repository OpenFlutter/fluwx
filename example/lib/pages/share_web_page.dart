import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class ShareWebPagePage extends StatefulWidget {
  const ShareWebPagePage({Key? key}) : super(key: key);

  @override
  ShareWebPagePageState createState() => ShareWebPagePageState();
}

class ShareWebPagePageState extends State<ShareWebPagePage> {
  String _url = 'share text from fluwx';
  String _title = 'Fluwx';
  String _thumnail = 'images/logo.png';
  WeChatScene scene = WeChatScene.session;

  Fluwx fluwx = Fluwx();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShareWebPage'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _share,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: TextEditingController(
                text: 'https://github.com/JarvanMo/fluwx',
              ),
              onChanged: (str) {
                _url = str;
              },
              decoration: const InputDecoration(labelText: 'web page'),
            ),
            TextField(
              controller: TextEditingController(text: 'Fluwx'),
              onChanged: (str) {
                _title = str;
              },
              decoration: const InputDecoration(labelText: 'thumbnail'),
            ),
            TextField(
              controller: TextEditingController(text: 'images/logo.png'),
              onChanged: (str) {
                _thumnail = str;
              },
              decoration: const InputDecoration(labelText: 'thumbnail'),
            ),
            Row(
              children: <Widget>[
                const Text('分享至'),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.session,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('会话')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.timeline,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('朋友圈')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.favorite,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('收藏')
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
    var model = WeChatShareWebPageModel(
      _url,
      title: _title,
      scene: scene,
    );
    fluwx.share(model);
  }

  void handleRadioValueChanged(WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}
