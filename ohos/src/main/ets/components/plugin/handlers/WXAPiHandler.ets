import * as wechatOpenSDK from "@tencent/wechat_open_sdk"
import { MethodCall, MethodResult } from '@ohos/flutter_ohos'
import { bundleManager, common } from '@kit.AbilityKit'

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

  static registerApp(call: MethodCall, result: MethodResult) {
    if (WXAPiHandler.wxApi != null) {
      result.success(true)
      return
    }
    const appId: string | null = call.argument("appId")
    if (!appId) {
      result.error("invalid app id", "are you sure your app id is correct ?", appId)
      return
    }

    WXAPiHandler.registerWxAPIInternal(appId)

    result.success(WXAPiHandler.registered)
  }

  static checkWeChatInstallation(result: MethodResult) {
    const isInstalled = bundleManager.canOpenLink("weixin://")
    result.success(isInstalled)
  }

  private static registerWxAPIInternal(appId: string) {
    let api = wechatOpenSDK.WXAPIFactory.createWXAPI(appId)
    WXAPiHandler.registered = true
    WXAPiHandler.wxApi = api
  }
}