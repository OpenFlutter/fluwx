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

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import com.tencent.mm.opensdk.modelmsg.ShowMessageFromWX
import io.flutter.plugin.common.MethodChannel
import com.tencent.mm.opensdk.modelbase.BaseReq
import java.lang.Exception

object FluwxRequestHandler {
    private const val KEY_FLUWX_REQUEST_INFO_BUNDLE = "KEY_FLUWX_REQUEST_INFO_BUNDLE"

    var customOnReqDelegate: ((baseReq: BaseReq, activity: Activity) -> Unit)? = null

    private var channel: MethodChannel? = null

    fun setMethodChannel(channel: MethodChannel) {
        FluwxRequestHandler.channel = channel
    }


    fun handleRequestInfoFromIntent(intent: Intent) {
        intent.getBundleExtra(KEY_FLUWX_REQUEST_INFO_BUNDLE)?.run {
            val type = getInt("_wxapi_command_type", -9999)
            if (type == 4) {
                handleShowMessageFromWXBundle(this)
            }
        }
    }

    private fun handleShowMessageFromWXBundle(bundle: Bundle) = handleWXShowMessageFromWX(ShowMessageFromWX.Req(bundle))

    private fun handleRequest(req: BaseReq) {
        when (req) {
            is ShowMessageFromWX.Req -> handleWXShowMessageFromWX(req)
        }
    }

    private fun handleWXShowMessageFromWX(req: ShowMessageFromWX.Req) {
        val result = mapOf(
                "extMsg" to req.message.messageExt,
        )
        channel?.invokeMethod("onWXShowMessageFromWX", result)
    }

    private fun defaultOnReqDelegate(baseReq: BaseReq, activity: Activity) {
        // FIXME: 可能是官方的Bug，从微信拉起APP的Intent类型不对，无法跳转回Flutter Activity
        // 稳定复现场景：微信版本为7.0.5，小程序SDK为2.7.7
        if (baseReq.type == 4) {
            // com.tencent.mm.opensdk.constants.ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX = 4
            if (WXAPiHandler.wxApiRegistered) {
                handleRequest(baseReq)
                startSpecifiedActivity(defaultFlutterActivityAction(activity), activity = activity)
            } else {
                startSpecifiedActivity(defaultFlutterActivityAction(activity), bundle = Bundle().apply {
                    baseReq.toBundle(this)
                }, bundleKey = KEY_FLUWX_REQUEST_INFO_BUNDLE, activity = activity)
            }
        }
    }

    fun onReq(baseReq: BaseReq, activity: Activity) {
        try {
            val appInfo = activity.packageManager.getApplicationInfo(activity.packageName, PackageManager.GET_META_DATA)
            val defaultHandle = appInfo.metaData.getBoolean("handleWeChatRequestByFluwx", true)
            if (defaultHandle) {
                defaultOnReqDelegate(baseReq, activity)
            } else {
                customOnReqDelegate?.invoke(baseReq, activity)
            }
        } catch (e: Exception) {
            Log.i("Fluwx", "can't load meta-data handleWeChatRequestByFluwx")
        }
    }

    private fun startSpecifiedActivity(action: String, activity: Activity, bundle: Bundle? = null, bundleKey: String? = null) {
        Intent(action).run {
            bundleKey?.let {
                putExtra(bundleKey, bundle)
            }
            addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
            activity.packageManager?.let {
                resolveActivity(it)?.also {
                    activity.startActivity(this)
                    activity.finish()
                }
            }
        }
    }

    private fun defaultFlutterActivityAction(context: Context): String = "$context.packageName.FlutterActivity"
}