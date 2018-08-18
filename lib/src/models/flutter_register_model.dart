class RegisterModel {
  final String appId;
  final bool doIOS;
  final bool doAndroid;

  RegisterModel({
    this.appId,
    this.doIOS: true,
    this.doAndroid: true});
  Map toMap(){
    return {
      "appId":appId,
      "iOS":doIOS,
      "android":doAndroid
    };
  }
}
