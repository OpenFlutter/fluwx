package com.jarvan.fluwx

import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.handler.FluwxLoginHandler
import com.jarvan.fluwx.handler.FluwxShareHandler
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
            FluwxShareHandler.setRegistrar(registrar)
            FluwxShareHandler.setMethodChannel(channel)
            channel.setMethodCallHandler(FluwxPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if(call.method ==  WeChatPluginMethods.REGISTER_APP ){
            FluwxShareHandler.registerApp(call,result)
            return
        }


        if(call.method == WeChatPluginMethods.UNREGISTER_APP){
            FluwxShareHandler.unregisterApp(call)
            result.success(true)
            return
        }

        if ("sendAuth" == call.method){
            FluwxLoginHandler.sendAuth(call,result)
            return
        }

        if( call.method.startsWith("share")){
            FluwxShareHandler.handle(call, result)
        }else{
            result.notImplemented()
        }

    }
}
