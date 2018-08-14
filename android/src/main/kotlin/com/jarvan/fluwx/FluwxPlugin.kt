package com.jarvan.fluwx

import com.jarvan.fluwx.constant.CallResult
import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.handler.WeChatPluginHandler
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class FluwxPlugin(private var registrar: Registrar) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "fluwx")
            WeChatPluginHandler.setRegistrar(registrar)
            WeChatPluginHandler.setMethodChannel(channel)
            channel.setMethodCallHandler(FluwxPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        when {
            WeChatPluginMethods.INIT == call.method -> {
                val api = WXAPIFactory.createWXAPI(registrar.context().applicationContext, call.arguments as String?)
                api.registerApp(call.arguments as String)
                WeChatPluginHandler.setWxApi(api)
            }
            WeChatPluginHandler.apiIsNull() -> {
                result.error(CallResult.RESULT_API_NULL, "please config  wxapi first", null)
                return
            }
            call.method.startsWith("share") -> {
                WeChatPluginHandler.handle(call, result)
            }
        }
    }
}
