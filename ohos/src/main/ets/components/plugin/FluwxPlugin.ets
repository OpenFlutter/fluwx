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
import * as wechatOpenSDK from "@tencent/wechat_open_sdk"
import { FluwxAuthHandler } from './handlers/FluwxAuthHandler';
import { AbilityConstant, common, Want } from '@kit.AbilityKit';
import { WXAPiHandler } from './handlers/WXAPiHandler';

const MESSAGE_CHANNEL_NAME = "com.jarvanmo/fluwx"
const KEY_ERR_STR = "errStr"
const KEY_ERR_CODE = "errCode"
const KEY_OPEN_ID = "openId"
const KEY_TYPE = "type"

/** FluwxPlugin **/
export default class FluwxPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware, NewWantListener, wechatOpenSDK.WXApiEventHandler {
  private channel: MethodChannel | null = null;
  private appContext: common.Context | null = null;
  private binding: AbilityPluginBinding | null = null;
  private authHandler: FluwxAuthHandler | null = null;

  getUniqueClassName(): string {
    return "FluwxPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), MESSAGE_CHANNEL_NAME);
    this.channel.setMethodCallHandler(this)
    this.appContext = binding.getApplicationContext();
    this.authHandler = new FluwxAuthHandler(this.channel);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.channel = null;
    this.appContext = null;
    this.authHandler = null;
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    WXAPiHandler.setContext(binding.getAbility().context);
    this.binding = binding;
    binding.addOnNewWantListener(this)
  }

  onDetachedFromAbility(): void {
    this.binding = null;
  }

  // 微信回调 start

  onReq = (req: wechatOpenSDK.BaseReq): void => {
  }
  onResp = (resp: wechatOpenSDK.BaseResp): void => {
    if (resp instanceof wechatOpenSDK.SendAuthResp) {
      this.handleAuthResponse(resp);
      return;
    }
  }

  // 微信回调 end


  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    WXAPiHandler.wxApi?.handleWant(want, this)
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
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
      case "isWeChatInstalled":
        WXAPiHandler.checkWeChatInstallation(result);
        break;
      default:
        result.notImplemented()
    }
  }

  handleAuthResponse(resp: wechatOpenSDK.SendAuthResp) {
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
}