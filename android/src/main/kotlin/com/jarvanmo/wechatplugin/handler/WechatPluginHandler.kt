package com.jarvanmo.wechatplugin.handler

import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.modelbase.BaseResp
import io.flutter.plugin.common.MethodCall
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.jarvanmo.wechatplugin.config.WechatPluginConfig
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage
import com.tencent.mm.opensdk.modelmsg.WXTextObject


/***
 * Created by mo on 2018/8/8
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
object WechatPluginHandler {
    var wxApi: IWXAPI? = null


    fun shareText(call: MethodCall) {

        val textObj = WXTextObject()
        textObj.text = call.argument(WechatPluginConfig.TEXT)
        val msg = WXMediaMessage()
        msg.mediaObject = textObj
        msg.description = call.argument(WechatPluginConfig.TEXT)
        val req = SendMessageToWX.Req()
        req.transaction = call.argument(WechatPluginConfig.TRANSACTION)
        req.message = msg
        req.scene = getScene(call.argument(WechatPluginConfig.SCENE))
        wxApi?.sendReq(req)

    }

    fun onResp(resp: BaseResp) {
        var result = 0
        when (resp.errCode) {
            BaseResp.ErrCode.ERR_OK -> {
            }
            BaseResp.ErrCode.ERR_USER_CANCEL -> {
            }
            BaseResp.ErrCode.ERR_AUTH_DENIED -> {
            }
            BaseResp.ErrCode.ERR_UNSUPPORT -> {
            }
            else -> {

            }
        }

    }

    private fun getScene(value: String) = when (value) {
        WechatPluginConfig.TIMELINE -> SendMessageToWX.Req.WXSceneTimeline
        WechatPluginConfig.SESSION -> SendMessageToWX.Req.WXSceneSession
        WechatPluginConfig.FAVORITE -> SendMessageToWX.Req.WXSceneFavorite
        else -> SendMessageToWX.Req.WXSceneTimeline

    }
}