package com.jarvan.fluwx.handler

import com.jarvan.fluwx.constant.CallResult
import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.constant.WechatPluginKeys
import com.jarvan.fluwx.utils.ShareImageUtil
import com.jarvan.fluwx.utils.WeChatThumbnailUtil
import com.tencent.mm.opensdk.modelmsg.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.experimental.CommonPool
import kotlinx.coroutines.experimental.android.UI
import kotlinx.coroutines.experimental.async
import kotlinx.coroutines.experimental.launch


/***
 * Created by mo on 2018/8/8
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
internal object FluwxShareHandler {


    private var channel: MethodChannel? = null

    private var registrar: PluginRegistry.Registrar? = null


    fun setMethodChannel(channel: MethodChannel) {
        FluwxShareHandler.channel = channel
    }


    fun setRegistrar(registrar: PluginRegistry.Registrar) {
        FluwxShareHandler.registrar = registrar
    }


    fun handle(call: MethodCall, result: MethodChannel.Result) {
        if (WXAPiHandler.wxApi == null) {
            result.error(CallResult.RESULT_API_NULL, "please config  wxapi first", null)
            return
        }

        if (!WXAPiHandler.wxApi!!.isWXAppInstalled) {
            result.error(CallResult.RESULT_WE_CHAT_NOT_INSTALLED, CallResult.RESULT_WE_CHAT_NOT_INSTALLED, null)
            return
        }

        when (call.method) {
            WeChatPluginMethods.SHARE_TEXT -> shareText(call, result)
            WeChatPluginMethods.SHARE_MINI_PROGRAM -> shareMiniProgram(call, result)
            WeChatPluginMethods.SHARE_IMAGE -> shareImage(call, result)
            WeChatPluginMethods.SHARE_MUSIC -> shareMusic(call, result)
            WeChatPluginMethods.SHARE_VIDEO -> shareVideo(call, result)
            WeChatPluginMethods.SHARE_WEB_PAGE -> shareWebPage(call, result)
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
        msg.description

        msg.messageAction = call.argument<String>(WechatPluginKeys.MESSAGE_ACTION)
        msg.messageExt = call.argument<String>(WechatPluginKeys.MESSAGE_EXT)
        msg.mediaTagName = call.argument<String>(WechatPluginKeys.MEDIA_TAG_NAME)

        setCommonArguments(call, req, msg)
        val done = WXAPiHandler.wxApi?.sendReq(req)
        result.success(
                mapOf(
                        WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                        WechatPluginKeys.RESULT to done
                )
        )

    }


    private fun shareMiniProgram(call: MethodCall, result: MethodChannel.Result) {
        val miniProgramObj = WXMiniProgramObject()
        miniProgramObj.webpageUrl = call.argument("webPageUrl") // 兼容低版本的网页链接
        miniProgramObj.miniprogramType = call.argument("miniProgramType")// 正式版:0，测试版:1，体验版:2
        miniProgramObj.userName = call.argument("userName")     // 小程序原始id
        miniProgramObj.path = call.argument("path")            //小程序页面路径
        miniProgramObj.withShareTicket = call.argument("withShareTicket")
        val msg = WXMediaMessage(miniProgramObj)
        msg.title = call.argument(WechatPluginKeys.TITLE)                   // 小程序消息title
        msg.description = call.argument("description")               // 小程序消息desc
        val thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)

        launch((UI)) {
            if (thumbnail.isNullOrBlank()) {
                msg.thumbData = null
            } else {
                msg.thumbData = getThumbnailByteArrayMiniProgram(registrar, thumbnail!!)
            }
            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            val done = WXAPiHandler.wxApi?.sendReq(req)
            result.success(
                    mapOf(
                            WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                            WechatPluginKeys.RESULT to done
                    )
            )

        }


    }

    private suspend fun getThumbnailByteArrayMiniProgram(registrar: PluginRegistry.Registrar?, thumbnail: String): ByteArray {

        return async(CommonPool) {
            val result = WeChatThumbnailUtil.thumbnailForMiniProgram(thumbnail, registrar)
            result ?: byteArrayOf()
        }.await()
    }

    private suspend fun getImageByteArrayCommon(registrar: PluginRegistry.Registrar?, imagePath: String): ByteArray {
        return async(CommonPool) {
            val result = ShareImageUtil.getImageData(registrar, imagePath)
            result ?: byteArrayOf()
        }.await()
    }

    private suspend fun getThumbnailByteArrayCommon(registrar: PluginRegistry.Registrar?, thumbnail: String): ByteArray {
        return async(CommonPool) {
            val result = WeChatThumbnailUtil.thumbnailForCommon(thumbnail, registrar)
            result ?: byteArrayOf()
        }.await()
    }

    private fun shareImage(call: MethodCall, result: MethodChannel.Result) {
        val imagePath = call.argument<String>(WechatPluginKeys.IMAGE)


        launch(UI) {
            val byteArray: ByteArray? = getImageByteArrayCommon(registrar, imagePath)

            val imgObj = if (byteArray != null && byteArray.isNotEmpty()) {
                WXImageObject(byteArray)
            } else {
                null
            }

            if (imgObj == null) {
                result.error(CallResult.RESULT_FILE_NOT_EXIST, CallResult.RESULT_FILE_NOT_EXIST, imagePath)
                return@launch
            }

            var thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)

            if (thumbnail.isNullOrBlank()) {
                thumbnail = imagePath
            }

            val thumbnailData = getThumbnailByteArrayCommon(registrar, thumbnail!!)

//           val thumbnailData =  Util.bmpToByteArray(bitmap,true)
            handleShareImage(imgObj, call, thumbnailData, result)
        }

    }

    private fun handleShareImage(imgObj: WXImageObject, call: MethodCall, thumbnailData: ByteArray?, result: MethodChannel.Result) {

        val msg = WXMediaMessage()
        msg.mediaObject = imgObj
        if (thumbnailData == null || thumbnailData.isEmpty()) {
            msg.thumbData = null
        } else {
            msg.thumbData = thumbnailData
        }

        msg.title = call.argument<String>(WechatPluginKeys.TITLE)
        msg.description = call.argument<String>(WechatPluginKeys.DESCRIPTION)

        val req = SendMessageToWX.Req()
        setCommonArguments(call, req, msg)
        req.message = msg
        val done = WXAPiHandler.wxApi?.sendReq(req)
        result.success(
                mapOf(
                        WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                        WechatPluginKeys.RESULT to done
                )
        )
    }

    private fun shareMusic(call: MethodCall, result: MethodChannel.Result) {
        val music = WXMusicObject()
        val musicUrl: String? = call.argument("musicUrl")
        val musicLowBandUrl: String? = call.argument("musicLowBandUrl")
        if (musicUrl != null && musicUrl.isNotBlank()) {
            music.musicUrl = musicUrl
            music.musicDataUrl = call.argument("musicDataUrl")
        } else {
            music.musicLowBandUrl = musicLowBandUrl
            music.musicLowBandDataUrl = call.argument("musicLowBandDataUrl")
        }
        val msg = WXMediaMessage()
        msg.mediaObject = music
        msg.title = call.argument("title")
        msg.description = call.argument("description")
        val thumbnail: String? = call.argument("thumbnail")

        launch(UI) {
            if (thumbnail != null && thumbnail.isNotBlank()) {
                msg.thumbData = getThumbnailByteArrayCommon(registrar, thumbnail)
            }

            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            val done = WXAPiHandler.wxApi?.sendReq(req)
            result.success(
                    mapOf(
                            WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                            WechatPluginKeys.RESULT to done
                    )
            )
        }


    }

    private fun shareVideo(call: MethodCall, result: MethodChannel.Result) {
        val video = WXVideoObject()
        val videoUrl: String? = call.argument("videoUrl")
        val videoLowBandUrl: String? = call.argument("videoLowBandUrl")
        if (videoUrl != null && videoUrl.isNotBlank()) {
            video.videoUrl = videoUrl
        } else {
            video.videoLowBandUrl = videoLowBandUrl
        }
        val msg = WXMediaMessage()
        msg.mediaObject = video
        msg.title = call.argument(WechatPluginKeys.TITLE)
        msg.description = call.argument(WechatPluginKeys.DESCRIPTION)
        val thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)

        launch(UI) {
            if (thumbnail != null && thumbnail.isNotBlank()) {
                msg.thumbData = getThumbnailByteArrayCommon(registrar, thumbnail)
            }
            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            val done = WXAPiHandler.wxApi?.sendReq(req)
            result.success(
                    mapOf(
                            WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                            WechatPluginKeys.RESULT to done
                    )
            )
        }


    }


    private fun shareWebPage(call: MethodCall, result: MethodChannel.Result) {
        val webPage = WXWebpageObject()
        webPage.webpageUrl = call.argument("webPage")
        val msg = WXMediaMessage()

        msg.mediaObject = webPage
        msg.title = call.argument(WechatPluginKeys.TITLE)
        msg.description = call.argument(WechatPluginKeys.DESCRIPTION)
        val thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)
        launch(UI) {
            if (thumbnail != null && thumbnail.isNotBlank()) {
                msg.thumbData = getThumbnailByteArrayCommon(registrar, thumbnail)
            }
            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            val done = WXAPiHandler.wxApi?.sendReq(req)
            result.success(
                    mapOf(
                            WechatPluginKeys.PLATFORM to WechatPluginKeys.ANDROID,
                            WechatPluginKeys.RESULT to done
                    )
            )
        }
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


    private fun getScene(value: String) = when (value) {
        WechatPluginKeys.SCENE_TIMELINE -> SendMessageToWX.Req.WXSceneTimeline
        WechatPluginKeys.SCENE_SESSION -> SendMessageToWX.Req.WXSceneSession
        WechatPluginKeys.SCENE_FAVORITE -> SendMessageToWX.Req.WXSceneFavorite
        else -> SendMessageToWX.Req.WXSceneTimeline
    }

    private fun setCommonArguments(call: MethodCall, req: SendMessageToWX.Req, msg: WXMediaMessage) {
        msg.messageAction = call.argument<String>(WechatPluginKeys.MESSAGE_ACTION)
        msg.messageExt = call.argument<String>(WechatPluginKeys.MESSAGE_EXT)
        msg.mediaTagName = call.argument<String>(WechatPluginKeys.MEDIA_TAG_NAME)
        req.transaction = call.argument(WechatPluginKeys.TRANSACTION)
        req.scene = getScene(call.argument(WechatPluginKeys.SCENE))
    }

}