
# 打开客服微信


```
 static Fluwx _fluwx = Fluwx();
  static Future<void> openCustomerServiceChat() async {
    bool isInstall = await _fluwx.isWeChatInstalled;
    if (!isInstall) {
      if (Platform.isIOS) {
        jumpToAppStore();
      } else {
        EasyLoading.showToast("UnInstall");
      }
      return;
    }
    CustomerServiceChat chat = CustomerServiceChat(
        corpId: "wwdxxxxxx", 
        url: "https://work.weixin.qq.com/kfid/kfcxxxxxx");
    _fluwx.open(target: chat);
  }
jumpToAppStore() async {
  final uri = Uri.parse('https://apps.apple.com/app/id414478124');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
```
