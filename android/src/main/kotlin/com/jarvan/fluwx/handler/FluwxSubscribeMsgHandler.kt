package com.jarvan.fluwx.handler

import com.tencent.mm.opensdk.modelbiz.SubscribeMessage
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel



/// create 2018/12/20 by cai


class FluwxSubscribeMsgHandler {
    fun subScribeMsg(call: MethodCall, result: MethodChannel.Result) {
        val appId = call.argument<String>("appId")
        val scene = call.argument<Int>("scene")
        val templateId = call.argument<String>("templateId")
        val reserved = call.argument<String>("reserved")

        val req = SubscribeMessage.Req()
        req.openId = appId
        req.scene = scene!!
        req.reserved = reserved
        req.templateID = templateId
        val b = WXAPiHandler.wxApi?.sendReq(req)
        result.success(b)
    }
}