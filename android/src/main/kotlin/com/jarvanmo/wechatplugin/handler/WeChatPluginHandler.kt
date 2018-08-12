package com.jarvanmo.wechatplugin.handler

import android.graphics.BitmapFactory
import android.util.Log
import com.jarvanmo.wechatplugin.WechatPlugin
import com.jarvanmo.wechatplugin.config.WeChatPluginImageSchema
import com.jarvanmo.wechatplugin.config.WeChatPluginMethods
import com.jarvanmo.wechatplugin.config.WechatPluginConfig
import com.jarvanmo.wechatplugin.utils.AssetManagerUtil
import com.jarvanmo.wechatplugin.utils.FileUtil
import com.jarvanmo.wechatplugin.utils.WeChatThumbnailUtil
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelmsg.*
import com.tencent.mm.opensdk.openapi.IWXAPI
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.net.URL


/***
 * Created by mo on 2018/8/8
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
object WeChatPluginHandler {
    private var wxApi: IWXAPI? = null

    private var channel: MethodChannel? = null

    private var registrar: PluginRegistry.Registrar? = null


    fun apiIsNull() = wxApi == null

    fun setMethodChannel(channel: MethodChannel) {
        this.channel = channel
    }

    fun setWxApi(wxApi: IWXAPI) {
        this.wxApi = wxApi
    }

    fun setRegistrar(registrar: PluginRegistry.Registrar) {
        this.registrar = registrar
    }


    fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            WeChatPluginMethods.SHARE_TEXT -> shareText(call,result)
            WeChatPluginMethods.SHARE_MINI_PROGRAM -> shareMiniProgram(call, result)
            WeChatPluginMethods.SHARE_IMAGE -> shareImage(call, result)
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun shareText(call: MethodCall, result: MethodChannel.Result) {
        val textObj = WXTextObject()
        textObj.text = call.argument(WechatPluginConfig.TEXT)
        val msg = WXMediaMessage()
        msg.mediaObject = textObj
        msg.description = call.argument(WechatPluginConfig.TEXT)
        val req = SendMessageToWX.Req()
        req.message = msg
        setCommonArguments(call,req)
        wxApi?.sendReq(req)
        result.success(true)
    }


    private fun shareMiniProgram(call: MethodCall, result: MethodChannel.Result) {
        val miniProgramObj = WXMiniProgramObject()
        miniProgramObj.webpageUrl = call.argument("webPageUrl") // 兼容低版本的网页链接
        miniProgramObj.miniprogramType = call.argument("miniProgramType")// 正式版:0，测试版:1，体验版:2
        miniProgramObj.userName = call.argument("userName")     // 小程序原始id
        miniProgramObj.path = call.argument("path")            //小程序页面路径
        val msg = WXMediaMessage(miniProgramObj)
        msg.title = call.argument("title")                   // 小程序消息title
        msg.description = call.argument("description")               // 小程序消息desc
        var thumbnail: String? = call.argument(WechatPluginConfig.THUMBNAIL)
        thumbnail = thumbnail ?: ""

        if (thumbnail.isNullOrBlank()) {
            msg.thumbData = null
        } else {
            msg.thumbData = WeChatThumbnailUtil.thumbnailForMiniProgram(thumbnail, registrar)
        }


        val req = SendMessageToWX.Req()
        setCommonArguments(call, req)
        req.message = msg
        wxApi?.sendReq(req)
        result.success(true)

    }

    private fun shareImage(call: MethodCall, result: MethodChannel.Result) {
        val imagePath = call.argument<String>(WechatPluginConfig.IMAGE)
        val imgObj = createWxImageObject(imagePath)
        if (imgObj == null) {
            result.error(WechatPlugin.TAG,WechatPlugin.FILE_NOT_EXIST,imagePath)
            return
        }


//        val bmp = BitmapFactory.decodeResource(getResources(), R.drawable.send_img)
//        val imgObj = WXImageObject(bmp)
//
        val msg = WXMediaMessage()
        msg.mediaObject = imgObj
//
//        val thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE, THUMB_SIZE, true)
//        bmp.recycle()
        msg.thumbData = WeChatThumbnailUtil.thumbnailForCommon(call.argument(WechatPluginConfig.THUMBNAIL), registrar)
//
        val req = SendMessageToWX.Req()
        setCommonArguments(call,req)
//        req.message = msg
        wxApi?.sendReq(req)
        result.success(true)
    }

    private fun createWxImageObject(imagePath:String):WXImageObject?{
        var imgObj: WXImageObject? = null
        var imageFile:File? = null
        if (imagePath.startsWith(WeChatPluginImageSchema.SCHEMA_ASSETS)){
            val key = imagePath.substring(WeChatPluginImageSchema.SCHEMA_ASSETS.length, imagePath.length)
            val assetFileDescriptor = AssetManagerUtil.openAsset(registrar,key,"")
            imageFile  = FileUtil.createTmpFile(assetFileDescriptor)
        }else if (imagePath.startsWith(WeChatPluginImageSchema.SCHMEA_FILE)){
            imageFile = File(imagePath)
        }
        if(imageFile != null && imageFile.exists()){
            imgObj = WXImageObject()
            imgObj.setImagePath(imagePath)
        }else{
            Log.d(WechatPlugin.TAG,WechatPlugin.FILE_NOT_EXIST)
        }

        return  imgObj
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

    private fun getScene(value: String) = when (value.toLowerCase()) {
        WechatPluginConfig.TIMELINE -> SendMessageToWX.Req.WXSceneTimeline
        WechatPluginConfig.SESSION -> SendMessageToWX.Req.WXSceneSession
        WechatPluginConfig.FAVORITE -> SendMessageToWX.Req.WXSceneFavorite
        else -> SendMessageToWX.Req.WXSceneTimeline
    }

    private fun setCommonArguments(call: MethodCall, req: SendMessageToWX.Req) {
        req.transaction = call.argument(WechatPluginConfig.TRANSACTION)
        req.scene = getScene(call.argument(WechatPluginConfig.SCENE))
    }

}