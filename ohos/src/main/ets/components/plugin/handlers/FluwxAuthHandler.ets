import { MethodCall, MethodChannel, MethodResult } from "@ohos/flutter_ohos";
import { DiffDevOAuthFactory, IDiffDevOAuth, OAuthCallback, OAuthErrCode, SendAuthReq } from "@tencent/wechat_open_sdk";
import { WXAPiHandler } from "./WXAPiHandler";
import { util } from "@kit.ArkTS";

export class FluwxAuthHandler implements OAuthCallback {
  private channel: MethodChannel;
  private diffDevOauth: IDiffDevOAuth | null = null;

  constructor(channel: MethodChannel) {
    this.channel = channel;
  }

  onGotQRCode = (base64JpegImageBuffer: string) => {
    const base64Codec = new util.Base64Helper()
    const bytes = base64Codec.decodeSync(base64JpegImageBuffer)

    this.channel.invokeMethod("onAuthGotQRCode", {
      "errCode": 0,
      "qrCode": bytes
    })
  }
  onQRCodeScanned = () => {
    this.channel.invokeMethod("onQRCodeScanned", {
      "errCode": 0
    })
  }
  onAuthFinish = (authCode: string) => {
    this.channel.invokeMethod("onAuthByQRCodeFinished", {
      "authCode": authCode,
      "errCode": 0
    })
  }
  onAuthError = (errCode: OAuthErrCode, errMsg: string) => {
    this.channel.invokeMethod("onAuthByQRCodeFinished", {
      "errCode": errCode,
      "errStr": errMsg
    })
  }

  getDiffDevOauth(): IDiffDevOAuth {
    if (this.diffDevOauth) {
      this.diffDevOauth.stopOAuth();
      this.diffDevOauth = null;
    }
    this.diffDevOauth = DiffDevOAuthFactory.getDiffDevOAuth()!;
    return this.diffDevOauth;
  }

  async sendAuth(call: MethodCall, result: MethodResult) {
    const req = new SendAuthReq();
    req.isOption1 = false;
    req.scope = call.argument("scope");
    req.state = call.argument("state");
    const openid: string | null = call.argument("openid");
    if (openid) {
      req.openId = openid;
    }
    req.nonAutomatic = call.argument("nonAutomatic") ?? false;

    const done = await WXAPiHandler.wxApi?.sendReq(WXAPiHandler.uiContext, req);

    result.success(done);
  }

  authByQRCode(call: MethodCall, result: MethodResult) {
    const appId: string = call.argument("appId") ?? "";
    const scope: string = call.argument("scope") ?? "";
    const nonceStr: string = call.argument("nonceStr") ?? "";
    const timeStamp: string = call.argument("timeStamp") ?? "";
    const signature: string = call.argument("signature") ?? "";

    const qrCodeAuth = this.getDiffDevOauth();

    result.success(qrCodeAuth.startOAuth(
      appId,
      scope,
      nonceStr,
      timeStamp,
      signature,
      this
    ))
  }

  stopAuthByQRCode(result: MethodResult) {
    result.success(this.diffDevOauth?.stopOAuth())
  }
}