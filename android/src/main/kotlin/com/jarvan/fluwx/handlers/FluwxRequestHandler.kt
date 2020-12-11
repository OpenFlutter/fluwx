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
import com.tencent.mm.opensdk.modelmsg.ShowMessageFromWX
import io.flutter.plugin.common.MethodChannel
import com.tencent.mm.opensdk.modelbase.BaseReq

object FluwxRequestHandler {
    private var channel: MethodChannel? = null

    fun setMethodChannel(channel: MethodChannel) {
        FluwxRequestHandler.channel = channel
    }

    fun handleRequest(req: BaseReq) {
        when (req) {
            is ShowMessageFromWX.Req -> hanleWXShowMessageFromWX(req)
        }
    }

    private  fun hanleWXShowMessageFromWX(req: ShowMessageFromWX.Req) {
        val result = mapOf(
                "extMsg" to req.message.messageExt, )
        channel?.invokeMethod("onWXShowMessageFromWX", result)
    }
}