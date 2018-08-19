import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluwx/fluwx.dart';
import 'share_image_page.dart';
import 'share_text_image.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Fluwx.registerApp(RegisterModel(appId: "wxd930ea5d5a258f4f"));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: <String, WidgetBuilder>{
        "shareText": (context) => ShareTextPage(),
        "shareImage":(context) => ShareImagePage()
      },
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ShareSelectorPage()),
    );
  }
}

//  var fluwx = Fluwx();
////                fluwx.share(WeChatShareMiniProgramModel(
////                  webPageUrl: "http://www.qq.com",
////                  miniProgramType:
////                  WeChatShareMiniProgramModel.MINI_PROGRAM_TYPE_RELEASE,
////                  userName: "gh_d43f693ca31f",
////                  path: '/pages/media',
////                  title: "title",
////                  description: "des",
////                  thumbnail:
////                      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534532387799&di=12701cc3f20c1a78a5c7524ec33b4c59&imgtype=0&src=http%3A%2F%2Fwww.cssxt.com%2Fuploadfile%2F2017%2F1208%2F20171208110834538.jpg',
////                ));
////                thumbnail: 'http://b.hiphotos.baidu.com/image/h%3D300/sign=4bfc640817d5ad6eb5f962eab1c939a3/8718367adab44aedb794e128bf1c8701a08bfb20.jpg',
//  fluwx.share(
//  WeChatShareWebPageModel(
//  webPage: "https://github.com/JarvanMo/fluwx",
//  title: "MyGithub",
//  thumbnail: "assets://images/logo.png"
//  )
//  ).then((result){
//  print("--$result");
//  },onError: (msg){
//  print(msg);
//  });
////              fluwx.share(WeChatShareImageModel(image: "imagePath",thumbnail: "thumbanailPath"));
class ShareSelectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new OutlineButton(onPressed: () {
          Navigator.of(context).pushNamed("shareText");
        }, child: const Text("share text")),
        new OutlineButton(onPressed: () {
          Navigator.of(context).pushNamed("shareImage");
        }, child: const Text("share image")),
        new OutlineButton(onPressed: () {}, child: const Text("share webpage")),
      ],
    );
  }
}
