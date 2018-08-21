package com.jarvan.fluwx.handler

import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelmsg.SendAuth
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object FluwxLoginHandler {

    private var channel: MethodChannel? = null



    fun setMethodChannel(channel: MethodChannel) {
        FluwxLoginHandler.channel = channel
    }

    fun sendAuth(call: MethodCall, result: MethodChannel.Result) {
        val req = SendAuth.Req()
        req.scope = call.argument("scope")
        req.state = call.argument("state")
        result.success(WXAPiHandler.wxApi!!.sendReq(req))
    }

    fun  handleResponse(response:BaseResp){


    }



}