package com.jarvan.fluwx_example

import android.os.Bundle

import com.jarvan.fluwx.handlers.FluwxRequestHandler
import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //If you didn't configure WxAPI, add the following code
//        WXAPiHandler.setupWxApi("wxd930ea5d5a258f4f",this)
        //Get Ext-Info from Intent.
        FluwxRequestHandler.handleRequestInfoFromIntent(intent)
    }
}
