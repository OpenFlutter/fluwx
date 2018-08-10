package com.jarvanmo.wechatplugin.handler

import android.annotation.SuppressLint
import android.content.Context
import com.jarvanmo.wechatplugin.config.WeChatPluginMethods
import com.jarvanmo.wechatplugin.config.WechatPluginConfig
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage
import com.tencent.mm.opensdk.modelmsg.WXMiniProgramObject
import com.tencent.mm.opensdk.modelmsg.WXTextObject
import com.tencent.mm.opensdk.openapi.IWXAPI
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import top.zibin.luban.Luban


@SuppressLint("StaticFieldLeak")
/***
 * Created by mo on 2018/8/8
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
object WeChatPluginHandler {
    private var wxApi: IWXAPI? = null

    private var channel: MethodChannel? = null

    private var context: Context? = null


    fun apiIsNull() = wxApi == null

    fun setMethodChannel(channel: MethodChannel) {
        this.channel = channel
    }

    fun setWxApi(wxApi: IWXAPI) {
        this.wxApi = wxApi
    }

    fun setContext(context: Context){
        this.context = context.applicationContext
    }


    fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            WeChatPluginMethods.SHARE_TEXT -> shareText(call)
            WeChatPluginMethods.SHARE_MINI_PROGRAM -> shareMiniProgram(call)
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


    private  fun shareMiniProgram(call: MethodCall){
        val miniProgramObj = WXMiniProgramObject()
        miniProgramObj.webpageUrl = call.argument("webPageUrl") // 兼容低版本的网页链接
        miniProgramObj.miniprogramType = call.argument("miniProgramType")// 正式版:0，测试版:1，体验版:2
        miniProgramObj.userName = call.argument("userName")     // 小程序原始id
        miniProgramObj.path = call.argument("path")            //小程序页面路径
        val msg = WXMediaMessage(miniProgramObj)
        msg.title = call.argument("title")                   // 小程序消息title
        msg.description = call.argument("description")               // 小程序消息desc
//        msg.thumbData = getThumb()                      // 小程序消息封面图片，小于128k


        val req = SendMessageToWX.Req()
        req.transaction = call.argument("transaction")
        req.message = msg
        req.scene = call.argument("scene")  // 目前支持会话
        wxApi.sendReq(req)
    }

    fun onResp(resp: BaseResp) {
        val result = mapOf(
                "errStr" to resp.errStr,
                "transaction" to resp.transaction,
                "type" to resp.type,
                "errCode" to resp.errCode,
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