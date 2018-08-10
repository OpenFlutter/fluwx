package com.jarvanmo.wechatplugin

import com.jarvanmo.wechatplugin.config.WeChatPluginMethods
import com.jarvanmo.wechatplugin.handler.WeChatPluginHandler
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class WechatPlugin(private var channel: MethodChannel,private var registrar: Registrar) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "wechat_plugin")
            WeChatPluginHandler.setContext(registrar.context().applicationContext)
            channel.setMethodCallHandler(WechatPlugin(channel,registrar))
            WeChatPluginHandler.setMethodChannel(channel)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        when {
            WeChatPluginMethods.INIT == call.method -> {
                val api =  WXAPIFactory.createWXAPI(registrar.context().applicationContext, call.arguments as String?)
                WeChatPluginHandler.setWxApi(api)
            }
            WeChatPluginHandler.apiIsNull() -> {
                result.error("config your wxapi first", "config your wxapi first", null)
                return
            }
            else -> WeChatPluginHandler.handle(call, result)
        }


    }

}
