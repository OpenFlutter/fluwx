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
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

object WXAPiHandler {

    private var registrar: PluginRegistry.Registrar? = null
    var wxApi: IWXAPI? = null


    fun setRegistrar(registrar: PluginRegistry.Registrar) {
        WXAPiHandler.registrar = registrar
    }


    fun registerApp(call: MethodCall, result: MethodChannel.Result) {

        if (call.argument<Boolean>(WechatPluginKeys.ANDROID) == false) {
            return
        }

        if (wxApi != null) {
            result.success(mapOf(
                    WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                    WechatPluginKeys.RESULT to true
            ))
            return
        }

        val appId: String? = call.argument(WechatPluginKeys.APP_ID)
        if (appId.isNullOrBlank()) {
            result.error("invalid app id", "are you sure your app id is correct ?", appId)
            return
        }


        val api = WXAPIFactory.createWXAPI(registrar!!.context().applicationContext, appId, call.argument<Boolean>("enableMTA")!!)
        val registered = api.registerApp(appId)
        wxApi = api
        result.success(mapOf(
                WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                WechatPluginKeys.RESULT to registered
        ))
    }

    fun checkWeChatInstallation(result: MethodChannel.Result) {
        if (wxApi == null) {
            result.error(CallResult.RESULT_API_NULL, "please config  wxapi first", null)
            return
        } else {
            result.success(wxApi!!.isWXAppInstalled)
        }

    }
}