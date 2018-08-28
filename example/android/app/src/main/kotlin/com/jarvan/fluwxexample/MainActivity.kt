package com.jarvan.fluwxexample

import android.os.Bundle
import net.sourceforge.simcpux.wxapi.WXEntryActivity
import net.sourceforge.simcpux.wxapi.WXPayEntryActivity

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity() : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
    }
}
