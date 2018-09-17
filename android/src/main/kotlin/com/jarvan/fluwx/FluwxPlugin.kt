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
package com.jarvan.fluwx

import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.constant.WeChatPluginMethods.IS_WE_CHAT_INSTALLED
import com.jarvan.fluwx.handler.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FluwxPlugin(private var registrar: Registrar) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "com.jarvanmo/fluwx")
            WXAPiHandler.setRegistrar(registrar)
            FluwxShareHandler.setRegistrar(registrar)
            FluwxShareHandler.setMethodChannel(channel)
            FluwxResponseHandler.setMethodChannel(channel)
            channel.setMethodCallHandler(FluwxPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method == WeChatPluginMethods.REGISTER_APP) {
            WXAPiHandler.registerApp(call, result)
            return
        }


        if (call.method == WeChatPluginMethods.UNREGISTER_APP) {
//            FluwxShareHandler.unregisterApp(call)
//            result.success(true)
            return
        }

        if (call.method == IS_WE_CHAT_INSTALLED) {
            WXAPiHandler.checkWeChatInstallation(result)
            return
        }

        if ("sendAuth" == call.method) {
            FluwxAuthHandler.sendAuth(call, result)
            return
        }

        if (call.method == WeChatPluginMethods.PAY) {
            FluwxPayHandler.pay(call, result)
            return
        }

        if (call.method.startsWith("share")) {
            FluwxShareHandler.handle(call, result)
        } else {
            result.notImplemented()
        }


    }
}
