package com.jarvan.fluwx.handler

import com.jarvan.fluwx.constant.CallResult
import com.jarvan.fluwx.constant.WechatPluginKeys
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object FluwxPayHandler {


    fun pay(call: MethodCall, result: MethodChannel.Result) {

        if (WXAPiHandler.wxApi == null) {
            result.error(CallResult.RESULT_API_NULL, "please config  wxapi first", null)
            return
        } else {

// 将该app注册到微信
            val request = PayReq()
            request.appId = call.argument("appId")
            request.partnerId = call.argument("partnerId")
            request.prepayId = call.argument("prepayId")
            request.packageValue = call.argument("packageValue")
            request.nonceStr = call.argument("nonceStr")
            request.timeStamp = call.argument("timeStamp")
            request.sign = call.argument("sign")
            request.signType = call.argument("signType")
            request.extData = call.argument("extData")
            val done = WXAPiHandler.wxApi!!.sendReq(request)
            result.success(
                    mapOf(
                            WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                            WechatPluginKeys.RESULT to done
                    )
            )

        }
    }


}