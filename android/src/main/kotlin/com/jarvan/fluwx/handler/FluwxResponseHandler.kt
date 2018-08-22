package com.jarvan.fluwx.handler

import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.constant.WechatPluginKeys
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelmsg.SendAuth
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import io.flutter.plugin.common.MethodChannel

object FluwxResponseHandler {

    private var channel: MethodChannel? = null

    private const val errStr = "errStr"
    private const val errCode = "errCode"
    private const val openId ="openId"
    private const val type = "type"

    fun setMethodChannel(channel: MethodChannel) {
        FluwxResponseHandler.channel = channel
    }



    fun handleResponse(response: BaseResp) {
        if (response is SendAuth.Resp) {
            handleAuthResponse(response)
        }else if (response is SendMessageToWX.Resp){
            handleSendMessageResp(response)
        }
    }

    private fun handleSendMessageResp(response: SendMessageToWX.Resp) {
        val result = mapOf(
                errStr to response.errStr,
                WechatPluginKeys.TRANSACTION to response.transaction,
                type to response.type,
                errCode to response.errCode,
                openId to response.openId,
                WechatPluginKeys.PLATFORM to "android"
        )

        channel?.invokeMethod(WeChatPluginMethods.WE_CHAT_SHARE_RESPONSE, result)

    }

    private fun  handleAuthResponse(response:SendAuth.Resp){
        val result = mapOf(
                WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                errCode to response.errCode,
                "code" to response.code,
                "state" to response.state,
                "lang" to response.lang,
                "country" to response.country,
                errStr to response.errStr,
                openId to response.openId,
                "url" to response.url,
                type to response.type,
                WechatPluginKeys.TRANSACTION to response.transaction
        )
        channel?.invokeMethod("onAuthResponse", result)
    }
}