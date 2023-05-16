package com.jarvan.fluwx.utils

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import com.jarvan.fluwx.FluwxConfigurations

internal const val KEY_FLUWX_REQUEST_INFO_EXT_MSG = "KEY_FLUWX_REQUEST_INFO_EXT_MSG"
internal const val KEY_FLUWX_REQUEST_INFO_BUNDLE = "KEY_FLUWX_REQUEST_INFO_BUNDLE"
internal const val KEY_FLUWX_EXTRA = "KEY_FLUWX_EXTRA"
internal const val FLAG_PAYLOAD_FROM_WECHAT = "FLAG_PAYLOAD_FROM_WECHAT"

internal fun Activity.startFlutterActivity(
    extra: Intent,
) {
    flutterActivityIntent()?.also { intent ->
        intent.addFluwxExtras()
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        intent.putExtra(KEY_FLUWX_EXTRA, extra)
        intent.putExtra(FLAG_PAYLOAD_FROM_WECHAT, true)
        try {
            startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            Log.w("fluwx", "Can not start activity for Intent: $intent")
        }
    }
}


internal fun Context.flutterActivityIntent(): Intent? {
    return if (FluwxConfigurations.flutterActivity.isBlank()) {
        packageManager.getLaunchIntentForPackage(packageName)
    } else {
        Intent().also {
            it.setClassName(this, "${packageName}.${FluwxConfigurations.flutterActivity}")
        }
    }
}

internal fun Intent.addFluwxExtras() {
    putExtra("fluwx_payload_from_fluwx", true)
}

internal fun Intent.readWeChatCallbackIntent(): Intent? {
    return if (getBooleanExtra(FLAG_PAYLOAD_FROM_WECHAT, false)) {
        getParcelableExtra(KEY_FLUWX_EXTRA)
    } else {
        null
    }
}
