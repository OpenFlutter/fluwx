package com.jarvanmo.wechatplugin.handler

import com.jarvanmo.wechatplugin.config.WeChatPluginMethods
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.modelbase.BaseResp
import io.flutter.plugin.common.MethodCall
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.jarvanmo.wechatplugin.config.WechatPluginConfig
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage
import com.tencent.mm.opensdk.modelmsg.WXTextObject
import io.flutter.plugin.common.MethodChannel


/***
 * Created by mo on 2018/8/8
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
object WeChatPluginHandler {
    private var wxApi: IWXAPI? = null

    private var channel: MethodChannel? = null


    fun apiIsNull() = wxApi == null

    fun setMethodChannel(channel: MethodChannel) {
        this.channel = channel
    }

    fun setWxApi(wxApi: IWXAPI) {
        this.wxApi = wxApi
    }

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            WeChatPluginMethods.SHARE_TEXT -> {
                shareText(call)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun shareText(call: MethodCall) {

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

        var code =-99
        when (resp.errCode) {
            BaseResp.ErrCode.ERR_OK -> {
                code = 0
            }
            BaseResp.ErrCode.ERR_COMM -> {
                code = 1
            }

            BaseResp.ErrCode.ERR_USER_CANCEL -> {
                code = 2
            }
            BaseResp.ErrCode.ERR_SENT_FAILED -> {
                code = -3
            }

            BaseResp.ErrCode.ERR_AUTH_DENIED -> {
                code = -4
            }
            BaseResp.ErrCode.ERR_UNSUPPORT -> {
                code = -5
            }

            else -> {
            }
        }


        val result = mapOf(
                "errStr" to resp.errStr,
                "transaction" to resp.transaction,
                "type" to resp.type,
                "errCode" to code,
                "openId" to resp.openId
        )


        channel?.invokeMethod(WeChatPluginMethods.WE_CHAT_RESPONSE, result)

    }

    private fun getScene(value: String) = when (value) {
        WechatPluginConfig.TIMELINE -> SendMessageToWX.Req.WXSceneTimeline
        WechatPluginConfig.SESSION -> SendMessageToWX.Req.WXSceneSession
        WechatPluginConfig.FAVORITE -> SendMessageToWX.Req.WXSceneFavorite
        else -> SendMessageToWX.Req.WXSceneTimeline

    }


}