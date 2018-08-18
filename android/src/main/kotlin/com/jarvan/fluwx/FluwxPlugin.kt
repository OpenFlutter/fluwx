package com.jarvan.fluwx

import com.jarvan.fluwx.constant.CallResult
import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.handler.WeChatPluginHandler
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
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
        if(call.method ==  WeChatPluginMethods.REGISTER_APP ){
            WeChatPluginHandler.registerApp(call,result)
            return
        }


        if(call.method == WeChatPluginMethods.UNREGISTER_APP){
            WeChatPluginHandler.unregisterApp(call)
            result.success(true)
            return
        }


        if( call.method.startsWith("share")){
            WeChatPluginHandler.handle(call, result)
        }else{
            result.notImplemented()
        }

    }
}
