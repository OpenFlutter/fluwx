import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class ShareVideoPage extends StatefulWidget {
  const ShareVideoPage({Key? key}) : super(key: key);

  @override
  State<ShareVideoPage> createState() => _ShareVideoPageState();
}

class _ShareVideoPageState extends State<ShareVideoPage> {
  String _videoUrl = 'http://www.qq.com';
  String _videoLowBandUrl = 'http://www.qq.com';
  String _title = 'Beyond';
  String _description = 'A Popular Rock Band From China';
  String _thumnail = 'images/logo.png';
  WeChatScene scene = WeChatScene.session;

  Fluwx fluwx = Fluwx();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShareVideoPage'),
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
                text: 'http://staff2.ustc.edu.cn/~wdw/softdown/index.asp/'
                    '0042515_05.ANDY.mp3',
              ),
              onChanged: (str) {
                _videoUrl = str;
              },
              decoration: const InputDecoration(labelText: 'video url'),
            ),
            TextField(
              controller: TextEditingController(text: 'http://www.qq.com'),
              onChanged: (str) {
                _videoLowBandUrl = str;
              },
              decoration:
                  const InputDecoration(labelText: 'video low band url'),
            ),
            TextField(
              controller: TextEditingController(text: 'Beyond'),
              onChanged: (str) {
                _title = str;
              },
              decoration: const InputDecoration(labelText: 'title'),
            ),
            TextField(
              controller:
                  TextEditingController(text: 'A Popular Rock Band From China'),
              onChanged: (str) {
                _description = str;
              },
              decoration: const InputDecoration(labelText: 'description'),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _share() {
    var model = WeChatShareVideoModel(
      videoUrl: _videoUrl,
      videoLowBandUrl: _videoLowBandUrl,
      thumbnail: WeChatImage.network(_thumnail),
      description: _description,
      scene: scene,
      title: _title,
    );
    fluwx.share(model);
  }

  void handleRadioValueChanged(WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}
