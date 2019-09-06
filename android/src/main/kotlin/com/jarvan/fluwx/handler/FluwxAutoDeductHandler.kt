package com.jarvan.fluwx.handler

import com.tencent.mm.opensdk.modelbiz.WXOpenBusinessWebview
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class FluwxAutoDeductHandler {
    fun signAutoDeduct(call: MethodCall, result: MethodChannel.Result) {


        val appId: String = call.argument<String>("appid") ?: ""
        val mchId = call.argument<String>("mch_id") ?: ""
        val planId = call.argument<String>("plan_id") ?: ""
        val contractCode = call.argument<String>("contract_code") ?: ""
        val requestSerial = call.argument<String>("request_serial") ?: ""
        val contractDisplayAccount = call.argument<String>("contract_display_account") ?: ""
        val notifyUrl = call.argument<String>("notify_url") ?: ""
        val version = call.argument<String>("version") ?: ""
        val sign = call.argument<String>("sign") ?: ""
        val timestamp = call.argument<String>("timestamp") ?: ""
        val returnApp = call.argument<String>("return_app") ?: ""
        val businessType = call.argument<Int>("businessType") ?: 12

        val map = HashMap<String, String>()
        map["appid"] = appId
        map["mch_id"] = mchId
        map["plan_id"] = planId
        map["contract_code"] = contractCode
        map["request_serial"] = requestSerial
        map["contract_display_account"] = contractDisplayAccount
        map["notify_url"] = notifyUrl
        map["version"] = version
        map["sign"] = sign
        map["timestamp"] = timestamp
        map["return_app"] = returnApp


        val req = WXOpenBusinessWebview.Req()
        req.businessType = businessType
        req.queryInfo = map
        val b = WXAPiHandler.wxApi?.sendReq(req)
        result.success(b)
    }
}