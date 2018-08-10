package com.jarvanmo.wechatplugin

import com.jarvanmo.wechatplugin.config.WechatPluginMethods
import com.jarvanmo.wechatplugin.handler.WechatPluginHandler
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class WechatPlugin(): MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar): Unit {
      val channel = MethodChannel(registrar.messenger(), "wechat_plugin")
      channel.setMethodCallHandler(WechatPlugin())

    }
  }

  override fun onMethodCall(call: MethodCall, result: Result): Unit {

    if(WechatPluginHandler.wxApi == null){
      result.error("config your wxapi first","config your wxapi first",null)
      return
    }

    when (call.method) {
      WechatPluginMethods.SHARE_TEXT -> {
        WechatPluginHandler.shareText(call)
      }
      else -> {
        result.notImplemented()
      }
    }

  }

}
