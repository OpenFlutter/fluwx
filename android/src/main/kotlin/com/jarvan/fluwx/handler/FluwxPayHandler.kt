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
            request.timeStamp = call.argument<Long>("timeStamp").toString()
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