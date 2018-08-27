package com.jarvan.fluwx.wxapi

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.jarvan.fluwx.handler.FluwxResponseHandler
import com.jarvan.fluwx.handler.WXAPiHandler
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler


open class FluwxWXEntryActivity:Activity(), IWXAPIEventHandler {



    // IWXAPI 是第三方app和微信通信的openapi接口

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)



        WXAPiHandler.wxApi?.handleIntent(intent, this)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        setIntent(intent)
        WXAPiHandler.wxApi?.handleIntent(intent, this)
    }


    override fun onReq(baseReq: BaseReq) {

    }

    // 第三方应用发送到微信的请求处理后的响应结果，会回调到该方法
    override fun onResp(resp: BaseResp) {

        FluwxResponseHandler.handleResponse(resp)
        finish()
    }


}