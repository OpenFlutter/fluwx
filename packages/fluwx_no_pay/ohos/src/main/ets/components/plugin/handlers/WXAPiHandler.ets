import * as wechatOpenSDK from "@tencent/wechat_open_sdk"
import { MethodCall, MethodResult } from '@ohos/flutter_ohos'
import { bundleManager, common, Want } from '@kit.AbilityKit'

export class WXAPiHandler {
  static wxApi: wechatOpenSDK.WXApi | null = null
  private static registered: boolean = false
  private static context: common.UIAbilityContext | null = null

  static get wxApiRegistered() {
    return WXAPiHandler.registered
  }
  static get uiContext() {
    return WXAPiHandler.context
  }

  static coolBoot: boolean = false

  static setContext(context: common.UIAbilityContext) {
    WXAPiHandler.context = context
  }

  static registerApp(call: MethodCall, result: MethodResult, eventHandler: wechatOpenSDK.WXApiEventHandler) {
    if (WXAPiHandler.wxApi == null) {
      const appId: string | null = call.argument("appId")
      if (!appId) {
        result.error("invalid app id", "are you sure your app id is correct ?", appId)
        return
      }
      WXAPiHandler.registerWxAPIInternal(appId)
    }

    WXAPiHandler.bindEventHandler(eventHandler)
    result.success(WXAPiHandler.registered)
  }

  // The SDK dispatches every response to the handler it received in the most recent handleWant() call,
  // and handleWant() is the only way to hand it one. Responses coming back through the openLink channel
  // (current WeChat versions) never go through onNewWant, so until something calls handleWant() the
  // handler is null and the SDK drops them silently (`this.eventHandler?.onResp(...)`). That is what
  // made the first auth / pay after every cold start time out (#773).
  //
  // An empty Want carries no WeChat payload, so this only binds the handler: nothing is dispatched and the
  // launch Want is left for attemptToResumeMsgFromWx(), which apps call once their subscribers are ready.
  private static bindEventHandler(eventHandler: wechatOpenSDK.WXApiEventHandler) {
    const noPayload: Want = {}
    WXAPiHandler.wxApi?.handleWant(noPayload, eventHandler)
  }

  static checkWeChatInstallation(result: MethodResult) {
    const isInstalled = bundleManager.canOpenLink("weixin://") || WXAPiHandler.wxApi?.isWXAppInstalled() === true;
    result.success(isInstalled);
  }

  static checkSupportOpenBusinessView(result: MethodResult) {
    if (!WXAPiHandler.wxApi) {
      result.error("Unassigned WxApi", "please config wxapi first", null);
      return;
    }

    const isInstalled = bundleManager.canOpenLink("weixin://") || WXAPiHandler.wxApi?.isWXAppInstalled() === true;
    if (!isInstalled) {
      result.error("WeChat Not Installed", "Please install the WeChat first", null);
      return;
    }

    result.success(true);
  }


  private static registerWxAPIInternal(appId: string) {
    let api = wechatOpenSDK.WXAPIFactory.createWXAPI(appId)
    WXAPiHandler.registered = true
    WXAPiHandler.wxApi = api
  }
}