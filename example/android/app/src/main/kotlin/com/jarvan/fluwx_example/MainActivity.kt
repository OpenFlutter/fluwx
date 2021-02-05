package com.jarvan.fluwx_example

import androidx.annotation.NonNull;
import com.jarvan.fluwx.handlers.FluwxRequestHandler
import com.jarvan.fluwx.handlers.WXAPiHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        //If you didn't configure WxAPI, add the following code
        WXAPiHandler.setupWxApi("wxd930ea5d5a258f4f",this)
        //Get Ext-Info from Intent.
        FluwxRequestHandler.handleRequestInfoFromIntent(intent)
    }
}
