/*
 * Copyright (C) 2020 The OpenFlutter Organization
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
package com.jarvan.fluwx.handlers

import com.tencent.mm.opensdk.diffdev.DiffDevOAuthFactory
import com.tencent.mm.opensdk.diffdev.OAuthErrCode
import com.tencent.mm.opensdk.diffdev.OAuthListener
import com.tencent.mm.opensdk.modelmsg.SendAuth
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class FluwxAuthHandler(private val methodChannel: MethodChannel) {
    //    private DiffDevOAuthFactory.getDiffDevOAuth()
    private val qrCodeAuth by lazy {
        DiffDevOAuthFactory.getDiffDevOAuth()
    }

    private val qrCodeAuthListener by lazy {
        object : OAuthListener {
            override fun onAuthFinish(p0: OAuthErrCode, authCode: String?) {
                methodChannel.invokeMethod("onAuthByQRCodeFinished", mapOf(
                        "errCode" to p0.code,
                        "authCode" to authCode
                ))
            }

            override fun onAuthGotQrcode(p0: String?, p1: ByteArray) {
                methodChannel.invokeMethod("onAuthGotQRCode", mapOf("errCode" to 0, "qrCode" to p1))
            }

            override fun onQrcodeScanned() {
                methodChannel.invokeMethod("onQRCodeScanned", mapOf("errCode" to 0))
            }

        }
    }


    fun sendAuth(call: MethodCall, result: MethodChannel.Result) {
        val req = SendAuth.Req()
        req.scope = call.argument("scope")
        req.state = call.argument("state")
        val openId = call.argument<String?>("openId")
        if (!openId.isNullOrBlank()) {
            req.openId = call.argument("openId")
        }

        result.success(WXAPiHandler.wxApi?.sendReq(req))
    }


    fun authByQRCode(call: MethodCall, result: MethodChannel.Result) {
        val appId = call.argument("appId") ?: ""
        val scope = call.argument("scope") ?: ""
        val nonceStr = call.argument("nonceStr") ?: ""
        val timeStamp = call.argument("timeStamp") ?: ""
        val signature = call.argument("signature") ?: ""
//        val schemeData = call.argument("schemeData")?:""

        result.success(qrCodeAuth.auth(appId, scope, nonceStr, timeStamp, signature, qrCodeAuthListener))
    }

    fun stopAuthByQRCode(result: MethodChannel.Result) {
        result.success(qrCodeAuth.stopAuth())
    }

    fun removeAllListeners() {
        qrCodeAuth.removeAllListeners()
    }
}