import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class ShareTextPage extends StatefulWidget {
  const ShareTextPage({Key? key}) : super(key: key);

  @override
  State<ShareTextPage> createState() => _ShareTextPageState();
}

class _ShareTextPageState extends State<ShareTextPage> {
  String _text = 'share text from fluwx';
  WeChatScene scene = WeChatScene.session;
  Fluwx fluwx = Fluwx();
  late FluwxCancelable cancelable;

  @override
  void initState() {
    super.initState();

    cancelable = fluwx.addSubscriber((response) {
      debugPrint("response is ${response.isSuccessful}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancelable.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShareText'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: (){
              _shareText();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: TextEditingController(text: 'share text from fluwx'),
              onChanged: (str) {
                _text = str;
              },
              decoration: const InputDecoration(labelText: 'TextToShare'),
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

  void _shareText() {
    fluwx.share(WeChatShareTextModel(_text, scene: scene));
  }

  void handleRadioValueChanged(WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}
