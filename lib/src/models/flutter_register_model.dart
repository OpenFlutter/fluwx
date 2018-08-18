class RegisterModel {
  final String appId;
  final bool doOnIOS;
  final bool doOnAndroid;

  RegisterModel({
    this.appId,
    this.doOnIOS: true,
    this.doOnAndroid: true});
  Map toMap(){
    return {
      "appId":appId,
      "iOS":doOnIOS,
      "android":doOnAndroid
    };
  }
}
