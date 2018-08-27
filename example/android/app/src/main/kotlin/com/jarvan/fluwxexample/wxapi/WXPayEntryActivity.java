package com.jarvan.fluwxexample.wxapi;

import android.app.Activity;

import com.jarvan.fluwx.handler.FluwxResponseHandler;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;

public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
        FluwxResponseHandler.INSTANCE.handleResponse(baseResp);
    }
}
