/*
 * Copyright (C) 2018 The OpenFlutter Organization
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.jarvan.fluwx.handler

import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.constant.WechatPluginKeys
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelbiz.SubscribeMessage
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram
import com.tencent.mm.opensdk.modelbiz.WXOpenBusinessWebview
import com.tencent.mm.opensdk.modelmsg.SendAuth
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.tencent.mm.opensdk.modelpay.PayResp
import io.flutter.plugin.common.MethodChannel

object FluwxResponseHandler {

    private var channel: MethodChannel? = null

    private const val errStr = "errStr"
    private const val errCode = "errCode"
    private const val openId = "openId"
    private const val type = "type"

    fun setMethodChannel(channel: MethodChannel) {
        FluwxResponseHandler.channel = channel
    }


    fun handleResponse(response: BaseResp) {
        when (response) {
            is SendAuth.Resp -> handleAuthResponse(response)
            is SendMessageToWX.Resp -> handleSendMessageResp(response)
            is PayResp -> handlePayResp(response)
            is WXLaunchMiniProgram.Resp -> handleLaunchMiniProgramResponse(response)
            is SubscribeMessage.Resp -> handleSubscribeMessage(response)
            is WXOpenBusinessWebview.Resp -> handlerWXOpenBusinessWebviewResponse(response)
        }
    }

    private fun handleSubscribeMessage(response: SubscribeMessage.Resp) {
        val result = mapOf(
                "openid" to response.openId,
                "templateId" to response.templateID,
                "action" to response.action,
                "reserved" to response.reserved,
                "scene" to response.scene
        )

        channel?.invokeMethod(WeChatPluginMethods.ON_SUBSCRIBE_MSG_RESP, result)
    }

    private fun handleLaunchMiniProgramResponse(response: WXLaunchMiniProgram.Resp) {
        val result = mutableMapOf(
                errStr to response.errStr,
                WechatPluginKeys.TRANSACTION to response.transaction,
                type to response.type,
                errCode to response.errCode,
                openId to response.openId,
                WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID
        )



        response.extMsg?.let {
            //            "extMsg" to response.extMsg,
            result["extMsg"] = response.extMsg
        }

        channel?.invokeMethod(WeChatPluginMethods.WE_CHAT_LAUNCHMINIPROGRAM_RESPONSE, result)
    }

    private fun handlePayResp(response: PayResp) {

        val result = mapOf(
                "prepayId" to response.prepayId,
                "returnKey" to response.returnKey,
                "extData" to response.extData,
                errStr to response.errStr,
                WechatPluginKeys.TRANSACTION to response.transaction,
                type to response.type,
                errCode to response.errCode,
                openId to response.openId,
                WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID

        )
        channel?.invokeMethod(WeChatPluginMethods.WE_CHAT_PAY_RESPONSE, result)
    }

    private fun handleSendMessageResp(response: SendMessageToWX.Resp) {
        val result = mapOf(
                errStr to response.errStr,
                WechatPluginKeys.TRANSACTION to response.transaction,
                type to response.type,
                errCode to response.errCode,
                openId to response.openId,
                WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID
        )

        channel?.invokeMethod(WeChatPluginMethods.WE_CHAT_SHARE_RESPONSE, result)

    }

    private fun handleAuthResponse(response: SendAuth.Resp) {
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


    private fun handlerWXOpenBusinessWebviewResponse(response:WXOpenBusinessWebview.Resp){
        val result = mapOf(
                WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                errCode to response.errCode,
                "businessType" to response.businessType,
                "resultInfo" to response.resultInfo,
                errStr to response.errStr,
                openId to response.openId,
                type to response.type,
                WechatPluginKeys.TRANSACTION to response.transaction
        )

        channel?.invokeMethod("onAutoDeductResponse", result)

    }

}