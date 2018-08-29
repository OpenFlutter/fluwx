class RegisterModel {
  final String appId;
  final bool doOnIOS;
  final bool doOnAndroid;
  final bool enableMTA;

  ///[appId] is not necessary.
  ///if [doOnIOS] is true ,fluwx will register WXApi on iOS.
  ///if [doOnAndroid] is true, fluwx will register WXApi on Android.
  RegisterModel({this.appId, this.doOnIOS: true, this.doOnAndroid: true,this.enableMTA = false});

  Map toMap() {
    return {"appId": appId,
      "iOS": doOnIOS,
      "android": doOnAndroid,
      "enableMTA":enableMTA
      };
  }
}
