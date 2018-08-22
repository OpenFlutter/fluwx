package com.jarvan.fluwx.handler

import com.tencent.mm.opensdk.modelmsg.SendAuth
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal object FluwxLoginHandler {

    fun sendAuth(call: MethodCall, result: MethodChannel.Result) {
        val req = SendAuth.Req()
        req.scope = call.argument("scope")
        req.state = call.argument("state")
        result.success(WXAPiHandler.wxApi?.sendReq(req))
    }

    fun hehe(){

    }
}