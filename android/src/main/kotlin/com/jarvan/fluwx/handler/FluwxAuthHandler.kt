package com.jarvan.fluwx.handler

import com.jarvan.fluwx.constant.WechatPluginKeys
import com.tencent.mm.opensdk.modelmsg.SendAuth
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal object FluwxAuthHandler {

    fun sendAuth(call: MethodCall, result: MethodChannel.Result) {
        val req = SendAuth.Req()
        req.scope = call.argument("scope")
        req.state = call.argument("state")
        req.openId = call.argument("openId")
        result.success(WXAPiHandler.wxApi?.sendReq(req))
    }

}