package com.jarvan.fluwx.utils

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log

internal const val KEY_FLUWX_REQUEST_INFO_EXT_MSG = "KEY_FLUWX_REQUEST_INFO_EXT_MSG"
internal const val KEY_FLUWX_REQUEST_INFO_BUNDLE = "KEY_FLUWX_REQUEST_INFO_BUNDLE"

internal fun Activity.startFlutterActivity(
    wxRequestBundle: Bundle? = null,
    bundle: Bundle? = null,
) {
    flutterActivityIntent()?.also { intent ->
        intent.addFluwxExtras()
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        bundle?.let {
            intent.putExtras(it)
        }

        wxRequestBundle?.let {
            intent.putExtra(KEY_FLUWX_REQUEST_INFO_BUNDLE, it)
        }

        try {
            startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            Log.w("fluwx", "Can not start activity for Intent: $intent")
        } finally {
            finish()
        }

    }
}


internal fun Context.flutterActivityIntent(): Intent? {
    val appInfo = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
    val flutterActivity = appInfo.metaData.getString("FluwxFlutterActivity", "")
    return if (flutterActivity.isBlank()) {
        packageManager.getLaunchIntentForPackage(packageName)
    } else {
        Intent().also {
            it.setClassName(this, "${packageName}.$flutterActivity")
        }
    }
}

internal fun Intent.addFluwxExtras() {
    putExtra("fluwx_payload_from_fluwx", true)
}