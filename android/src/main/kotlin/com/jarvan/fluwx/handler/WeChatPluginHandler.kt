package com.jarvan.fluwx.handler


import com.jarvan.fluwx.constant.CallResult
import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.constant.WechatPluginKeys
import com.jarvan.fluwx.utils.ShareImageUtil
import com.jarvan.fluwx.utils.WeChatThumbnailUtil
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelmsg.*
import com.tencent.mm.opensdk.openapi.IWXAPI
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage
import com.tencent.mm.opensdk.modelmsg.WXMusicObject


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
        WeChatPluginHandler.channel = channel
    }

    fun setWxApi(wxApi: IWXAPI) {
        WeChatPluginHandler.wxApi = wxApi
    }

    fun setRegistrar(registrar: PluginRegistry.Registrar) {
        WeChatPluginHandler.registrar = registrar
    }


    fun handle(call: MethodCall, result: MethodChannel.Result) {

        if (wxApi!!.isWXAppInstalled) {
            result.error(CallResult.RESULT_WE_CHAT_NOT_INSTALLED, CallResult.RESULT_WE_CHAT_NOT_INSTALLED, null)
            return
        }
        when (call.method) {
            WeChatPluginMethods.SHARE_TEXT -> shareText(call, result)
            WeChatPluginMethods.SHARE_MINI_PROGRAM -> shareMiniProgram(call, result)
            WeChatPluginMethods.SHARE_IMAGE -> shareImage(call, result)
            WeChatPluginMethods.SHARE_MUSIC -> shareMusic(call, result)
            WeChatPluginMethods.SHARE_VIDEO -> shareVideo(call, result)
            WeChatPluginMethods.SHARE_WEB_PAGE -> shareVideo(call, result)
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun shareText(call: MethodCall, result: MethodChannel.Result) {
        val textObj = WXTextObject()
        textObj.text = call.argument(WechatPluginKeys.TEXT)
        val msg = WXMediaMessage()
        msg.mediaObject = textObj
        msg.description = call.argument(WechatPluginKeys.TEXT)
        val req = SendMessageToWX.Req()
        req.message = msg
        setCommonArguments(call, req)
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
        var thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)
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
        val imagePath = call.argument<String>(WechatPluginKeys.IMAGE)
        val byteArray = ShareImageUtil.getImageData(registrar, imagePath)
        val imgObj = if (byteArray != null) {
            WXImageObject(byteArray)
        } else {
            null
        }

        if (imgObj == null) {
            result.error(CallResult.RESULT_FILE_NOT_EXIST, CallResult.RESULT_FILE_NOT_EXIST, imagePath)
            return
        }

        val msg = WXMediaMessage()
        msg.mediaObject = imgObj
        msg.thumbData = WeChatThumbnailUtil.thumbnailForCommon(call.argument(WechatPluginKeys.THUMBNAIL), registrar)
//
        val req = SendMessageToWX.Req()
        setCommonArguments(call, req)
//        req.message = msg
        wxApi?.sendReq(req)
        result.success(true)
    }

    private fun shareMusic(call: MethodCall, result: MethodChannel.Result) {
        val music = WXMusicObject()
        val musicUrl: String? = call.argument("musicUrl")
        val musicLowBandUrl: String? = call.argument("musicLowBandUrl")
        if (musicUrl != null) {
            music.musicUrl = musicUrl
        } else {
            music.musicLowBandUrl = musicLowBandUrl
        }
        val msg = WXMediaMessage()
        msg.mediaObject = music
        msg.title = call.argument("title")
        msg.description = call.argument("description")
        val thumbnail: String? = call.argument("thumbnail")
        if (thumbnail != null && thumbnail.isNotBlank()) {
            msg.thumbData = WeChatThumbnailUtil.thumbnailForCommon(thumbnail, registrar)
        }

        val req = SendMessageToWX.Req()
        setCommonArguments(call, req)
        req.message = msg
        wxApi?.sendReq(req)
        result.success(true)
    }

    private fun shareVideo(call: MethodCall, result: MethodChannel.Result) {
        val video = WXVideoObject()
        val videoUrl: String? = call.argument("videoUrl")
        val videoLowBandUrl: String? = call.argument("videoLowBandUrl")
        if (videoUrl != null) {
            video.videoUrl = videoUrl
        } else {
            video.videoLowBandUrl = videoLowBandUrl
        }
        val msg = WXMediaMessage()
        msg.mediaObject = video
        msg.title = call.argument(WechatPluginKeys.TITLE)
        msg.description = call.argument(WechatPluginKeys.DESCRIPTION)
        val thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)
        if (thumbnail != null && thumbnail.isNotBlank()) {
            msg.thumbData = WeChatThumbnailUtil.thumbnailForCommon(thumbnail, registrar)
        }

        val req = SendMessageToWX.Req()
        setCommonArguments(call, req)
        req.message = msg
        wxApi?.sendReq(req)
        result.success(true)
    }


    private fun shareWebPage(call: MethodCall, result: MethodChannel.Result) {
        val webPage = WXWebpageObject()
        webPage.webpageUrl = call.argument("webPage")
        val msg = WXMediaMessage()

        msg.mediaObject = webPage
        msg.title = call.argument(WechatPluginKeys.TITLE)
        msg.description = call.argument(WechatPluginKeys.DESCRIPTION)
        val thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)
        if (thumbnail != null && thumbnail.isNotBlank()) {
            msg.thumbData = WeChatThumbnailUtil.thumbnailForCommon(thumbnail, registrar)
        }

        val req = SendMessageToWX.Req()
        setCommonArguments(call, req)
        req.message = msg
        wxApi?.sendReq(req)
        result.success(true)
    }

    //    private fun createWxImageObject(imagePath:String):WXImageObject?{
//        var imgObj: WXImageObject? = null
//        var imageFile:File? = null
//        if (imagePath.startsWith(WeChatPluginImageSchema.SCHEMA_ASSETS)){
//            val key = imagePath.substring(WeChatPluginImageSchema.SCHEMA_ASSETS.length, imagePath.length)
//            val assetFileDescriptor = AssetManagerUtil.openAsset(registrar,key,"")
//            imageFile  = FileUtil.createTmpFile(assetFileDescriptor)
//        }else if (imagePath.startsWith(WeChatPluginImageSchema.SCHEMA_FILE)){
//            imageFile = File(imagePath)
//        }
//        if(imageFile != null && imageFile.exists()){
//            imgObj = WXImageObject()
//            imgObj.setImagePath(imagePath)
//        }else{
//            Log.d(WechatPlugin.TAG,CallResult.RESULT_FILE_NOT_EXIST)
//        }
//
//        return  imgObj
//    }
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
        WechatPluginKeys.TIMELINE -> SendMessageToWX.Req.WXSceneTimeline
        WechatPluginKeys.SESSION -> SendMessageToWX.Req.WXSceneSession
        WechatPluginKeys.FAVORITE -> SendMessageToWX.Req.WXSceneFavorite
        else -> SendMessageToWX.Req.WXSceneTimeline
    }

    private fun setCommonArguments(call: MethodCall, req: SendMessageToWX.Req) {
        req.transaction = call.argument(WechatPluginKeys.TRANSACTION)
        req.scene = getScene(call.argument(WechatPluginKeys.SCENE))
    }

}