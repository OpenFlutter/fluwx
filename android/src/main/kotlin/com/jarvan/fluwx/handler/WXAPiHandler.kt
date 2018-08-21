package com.jarvan.fluwx.handler

import com.jarvan.fluwx.constant.WechatPluginKeys
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

object WXAPiHandler {

    private var registrar: PluginRegistry.Registrar? = null
    var wxApi: IWXAPI? = null



    fun setRegistrar(registrar: PluginRegistry.Registrar) {
        WXAPiHandler.registrar = registrar
    }


    fun registerApp(call: MethodCall, result: MethodChannel.Result) {

        if(!call.argument<Boolean>(WechatPluginKeys.ANDROID)){
            return
        }

        if (wxApi != null) {
            result.success(mapOf(
                    WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                    WechatPluginKeys.RESULT to true
            ))
            return
        }

        val appId:String? = call.argument(WechatPluginKeys.APP_ID)
        if (appId.isNullOrBlank()) {
            result.error("invalid app id", "are you sure your app id is correct ?", appId)
            return
        }

        val api = WXAPIFactory.createWXAPI(registrar!!.context().applicationContext, appId)
        val registered = api.registerApp(appId)
        wxApi = api
        result.success(mapOf(
                WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                WechatPluginKeys.RESULT to registered
        ))
    }
}