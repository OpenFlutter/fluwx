/*
 * Copyright (c) 2020.  OpenFlutter Project
 *
 *   Licensed to the Apache Software Foundation (ASF) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  The ASF licenses this
 * file to you under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.jarvan.fluwx.handlers

import android.content.Context
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object WXAPiHandler {

    var wxApi: IWXAPI? = null

    private var context: Context? = null

    fun setContext(context: Context?) {
        WXAPiHandler.context = context
    }

    fun registerApp(call: MethodCall, result: MethodChannel.Result) {

        if (call.argument<Boolean?>("android") == false) {
            return
        }

        if (wxApi != null) {
            result.success(true)
            return
        }

        val appId: String? = call.argument("appId")
        if (appId.isNullOrBlank()) {
            result.error("invalid app id", "are you sure your app id is correct ?", appId)
            return
        }

        val api = WXAPIFactory.createWXAPI(context?.applicationContext, appId)
        val registered = api.registerApp(appId)
        wxApi = api
        result.success(registered)
    }

    fun checkWeChatInstallation(result: MethodChannel.Result) {
        if (wxApi == null) {
            result.error("Unassigned WxApi", "please config  wxapi first", null)
            return
        } else {
            result.success(wxApi?.isWXAppInstalled)
        }

    }
}