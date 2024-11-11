import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  NewWantListener,
} from '@ohos/flutter_ohos';
import * as wechatSDK from "@tencent/wechat_open_sdk"
import { FluwxAuthHandler } from './handlers/FluwxAuthHandler';
import { AbilityConstant, common, Want } from '@kit.AbilityKit';
import { WXAPiHandler } from './handlers/WXAPiHandler';
import { FluwxShareHandler } from './handlers/FluwxShareHandler';

const MESSAGE_CHANNEL_NAME = "com.jarvanmo/fluwx"
const KEY_ERR_STR = "errStr"
const KEY_ERR_CODE = "errCode"
const KEY_OPEN_ID = "openId"
const KEY_TYPE = "type"

/** FluwxPlugin **/
export default class FluwxPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware, NewWantListener, wechatSDK.WXApiEventHandler {
  private channel: MethodChannel | null = null;
  private appContext: common.Context | null = null;
  private uiContext: common.UIAbilityContext | null = null;
  private binding: AbilityPluginBinding | null = null
  private authHandler: FluwxAuthHandler | null = null;
  private shareHandler: FluwxShareHandler | null = null;
  private extMsg: string | null = null;

  getUniqueClassName(): string {
    return "FluwxPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), MESSAGE_CHANNEL_NAME);
    this.channel.setMethodCallHandler(this)
    this.appContext = binding.getApplicationContext();
    this.authHandler = new FluwxAuthHandler(this.channel);
    this.shareHandler = new FluwxShareHandler();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.channel = null;
    this.appContext = null;
    this.authHandler = null;
    this.shareHandler = null;
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.binding = binding
    this.uiContext = binding.getAbility().context;
    WXAPiHandler.setContext(this.uiContext);
    binding.addOnNewWantListener(this)
  }

  onDetachedFromAbility(): void {
    this.binding?.removeOnNewWantListener(this)
    this.binding = null
    this.uiContext = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method.startsWith("share")) {
      this.shareHandler?.share(call, result);
      return;
    }

    switch (call.method) {
      case "isWeChatInstalled":
        WXAPiHandler.checkWeChatInstallation(result);
        break;
      case "registerApp":
        WXAPiHandler.registerApp(call, result);
        break;
      case "sendAuth":
        this.authHandler?.sendAuth(call, result);
        break;
      case "authByQRCode":
        this.authHandler?.authByQRCode(call, result);
        break;
      case "stopAuthByQRCode":
        this.authHandler?.stopAuthByQRCode(result);
        break;
      case "payWithFluwx":
        this.handlePay(call, result);
        break;
      case "payWithHongKongWallet":
        // TODO
        result.notImplemented();
        break;
      case "launchMiniProgram":
        this.launchMiniProgram(call, result);
        break;
      case "subscribeMsg":
        // TODO
        result.notImplemented();
        break;
      case "autoDeduct":
        // TODO
        result.notImplemented();
        break;
      case "autoDeductV2":
        // TODO
        result.notImplemented();
        break;
      case "openWXApp":
        result.success(WXAPiHandler.wxApi?.openWechat(this.uiContext));
        break;
      case "getExtMsg":
        result.success(this.extMsg);
        this.extMsg = null;
        break;
      case "openWeChatCustomerServiceChat":
        // TODO
        result.notImplemented();
        break;
      case "checkSupportOpenBusinessView":
        // TODO
        result.notImplemented();
        break;
      case "openBusinessView":
        // TODO
        result.notImplemented();
        break;
      case "openWeChatInvoice":
        // TODO
        result.notImplemented();
        break;
      case "openUrl":
        // TODO
        result.notImplemented();
        break;
      case "openRankList":
        // TODO
        result.notImplemented();
        break;
      case "attemptToResumeMsgFromWx":
        this.attemptToResumeMsgFromWx(result);
        break;
      case "selfCheck":
        result.success(null)
        break;
      default:
        result.notImplemented();
    }
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    WXAPiHandler.wxApi?.handleWant(want, this);
  }

  // 微信回调 start

  onReq = (req: wechatSDK.BaseReq): void => {
    // TODO
  }
  onResp = (resp: wechatSDK.BaseResp): void => {
    if (resp instanceof wechatSDK.SendAuthResp) {
      this.onAuthResponse(resp);
      return;
    }

    if (resp instanceof wechatSDK.SendMessageToWXResp) {
      this.onSendMessageToWXResp(resp);
      return;
    }

    if (resp instanceof wechatSDK.PayResp) {
      this.onPayResp(resp);
      return;
    }

    if (resp instanceof wechatSDK.LaunchMiniProgramResp) {
      this.onLaunchMiniProgramResp(resp);
      return;
    }
  }

  // 微信回调 end

  onAuthResponse(resp: wechatSDK.SendAuthResp) {
    const result: Map<string, ESObject> = new Map();
    result.set(KEY_ERR_CODE, resp.errCode);
    result.set(KEY_ERR_STR, resp.errStr);
    result.set("code", resp.code);
    result.set("state", resp.state);
    result.set("lang", resp.lang);
    result.set("country", resp.country);
    result.set(KEY_OPEN_ID, resp.openId);
    result.set("url", resp.url);
    result.set(KEY_TYPE, resp.type);

    this.channel?.invokeMethod("onAuthResponse", result);
  }

  onSendMessageToWXResp(resp: wechatSDK.SendMessageToWXResp) {
    const _result: Map<string, ESObject> = new Map();
    _result.set(KEY_ERR_CODE, resp.errCode);
    _result.set(KEY_ERR_STR, resp.errStr);
    _result.set(KEY_TYPE, resp.type);
    _result.set(KEY_OPEN_ID, resp.openId);

    this.channel?.invokeMethod("onShareResponse", _result);
  }

  onPayResp(resp: wechatSDK.PayResp) {
    const _result: Map<string, ESObject> = new Map();
    _result.set(KEY_ERR_CODE, resp.errCode);
    _result.set(KEY_ERR_STR, resp.errStr);
    _result.set(KEY_TYPE, resp.type);
    _result.set("prepayId", resp.prepayId);
    _result.set("returnKey", resp.returnKey);
    _result.set("extData", resp.extData);

    this.channel?.invokeMethod("onPayResponse", _result);
  }

  onLaunchMiniProgramResp(resp: wechatSDK.LaunchMiniProgramResp) {
    const _result: Map<string, ESObject> = new Map();
    _result.set(KEY_ERR_CODE, resp.errCode);
    _result.set(KEY_ERR_STR, resp.errStr);
    _result.set(KEY_TYPE, resp.type);
    _result.set(KEY_OPEN_ID, resp.openId);

    if (resp.extMsg) {
      _result.set("extMsg", resp.extMsg);
    }

    this.channel?.invokeMethod("onLaunchMiniProgramResponse", _result);
  }

  async handlePay(call: MethodCall, result: MethodResult) {
    if (!WXAPiHandler.wxApi) {
      result.error("Unassigned WxApi", "please config wxapi first", null);
      return;
    }

    const request = new wechatSDK.PayReq();
    request.appId = call.argument("appId");
    request.partnerId = call.argument("partnerId");
    request.prepayId = call.argument("prepayId");
    request.packageValue = call.argument("packageValue");
    request.nonceStr = call.argument("nonceStr");
    request.timeStamp = call.argument("timeStamp").toString();
    request.sign = call.argument("sign");
    request.signType = call.argument("signType");
    request.extData = call.argument("extData");

    const done = await WXAPiHandler.wxApi?.sendReq(this.uiContext, request);

    result.success(done);
  }

  attemptToResumeMsgFromWx(result: MethodResult) {
    WXAPiHandler.wxApi?.handleWant(this.binding?.getAbility().launchWant, this)
  }

  async launchMiniProgram(call: MethodCall, result: MethodResult) {
    const request = new wechatSDK.LaunchMiniProgramReq();
    request.userName = call.argument("userName");
    request.path = call.argument("path");
    // sdk 内当前没 type 常量, 直接使用传入的参数
    request.miniprogramType = call.argument("miniprogramType") ?? 0;

    const done = await WXAPiHandler.wxApi?.sendReq(this.uiContext, request);

    result.success(done);
  }
}