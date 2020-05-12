import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class ShareImagePage extends StatefulWidget {
  @override
  _ShareImagePageState createState() => _ShareImagePageState();
}

class _ShareImagePageState extends State<ShareImagePage> {
  WeChatScene scene = WeChatScene.SESSION;
  String _imagePath =
//  "http://img-download.pchome.net/download/1k1/3a/3e/ofskcd-s1a.jpg"
      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534614311230&di=b17a892b366b5d002f52abcce7c4eea0&imgtype=0&src=http%3A%2F%2Fimg.mp.sohu.com%2Fupload%2F20170516%2F51296b2673704ae2992d0a28c244274c_th.png";

  String _response = "";

  WeChatImage source;
  WeChatImage thumbnail;

  @override
  void initState() {
    super.initState();
    weChatResponseEventHandler.listen((res) {
      if (res is WeChatShareResponse) {
        setState(() {
          _response = "state :${res.isSuccessful}";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text("shareImage"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: _shareImage)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "图片地址(仅限网络)"),
              controller: TextEditingController(
                  text:
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534614311230&di=b17a892b366b5d002f52abcce7c4eea0&imgtype=0&src=http%3A%2F%2Fimg.mp.sohu.com%2Fupload%2F20170516%2F51296b2673704ae2992d0a28c244274c_th.png"),
              onChanged: (value) {
                source = WeChatImage.network(value);
              },
              keyboardType: TextInputType.multiline,
            ),
            TextField(
              decoration: InputDecoration(labelText: "缩略地址"),
              controller: TextEditingController(text: "//images/logo.png"),
              onChanged: (value) {
                thumbnail = WeChatImage.asset(value);
              },
            ),
            new Row(
              children: <Widget>[
                const Text("分享至"),
                Row(
                  children: <Widget>[
                    new Radio<WeChatScene>(
                        value: WeChatScene.SESSION,
                        groupValue: scene,
                        onChanged: handleRadioValueChanged),
                    const Text("会话")
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Radio<WeChatScene>(
                        value: WeChatScene.TIMELINE,
                        groupValue: scene,
                        onChanged: handleRadioValueChanged),
                    const Text("朋友圈")
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Radio<WeChatScene>(
                        value: WeChatScene.FAVORITE,
                        groupValue: scene,
                        onChanged: handleRadioValueChanged),
                    const Text("收藏")
                  ],
                )
              ],
            ),
            Text(_response)
          ],
        ),
      ),
    );
  }

  void _shareImage() {
    shareToWeChat(WeChatShareImageModel(source, thumbnail: thumbnail));
  }

  void handleRadioValueChanged(WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}
