/*
 * Copyright (C) 2018 The OpenFlutter Organization
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.jarvan.fluwx.handler

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.jarvan.fluwx.constant.CallResult
import com.jarvan.fluwx.constant.WeChatPluginMethods
import com.jarvan.fluwx.constant.WechatPluginKeys
import com.jarvan.fluwx.utils.ShareImageUtil
import com.jarvan.fluwx.utils.ThumbnailCompressUtil
import com.jarvan.fluwx.utils.WeChatThumbnailUtil
import com.tencent.mm.opensdk.modelmsg.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.*
import java.io.ByteArrayInputStream


/***
 * Created by mo on 2018/8/8
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
internal class FluwxShareHandler {


    private var channel: MethodChannel? = null

    private var registrar: PluginRegistry.Registrar? = null


    fun setMethodChannel(channel: MethodChannel) {
        this.channel = channel
    }


    fun setRegistrar(registrar: PluginRegistry.Registrar) {
        this.registrar = registrar
    }


    fun handle(call: MethodCall, result: MethodChannel.Result) {
        if (WXAPiHandler.wxApi == null) {
            result.error(CallResult.RESULT_API_NULL, "please config  wxapi first", null)
            return
        }
//
//        if (!WXAPiHandler.wxApi!!.isWXAppInstalled) {
//            result.error(CallResult.RESULT_WE_CHAT_NOT_INSTALLED, CallResult.RESULT_WE_CHAT_NOT_INSTALLED, null)
//            return
//        }

        when (call.method) {
            WeChatPluginMethods.SHARE_TEXT -> shareText(call, result)
            WeChatPluginMethods.SHARE_MINI_PROGRAM -> shareMiniProgram(call, result)
            WeChatPluginMethods.SHARE_IMAGE -> shareImage(call, result)
            WeChatPluginMethods.SHARE_MUSIC -> shareMusic(call, result)
            WeChatPluginMethods.SHARE_VIDEO -> shareVideo(call, result)
            WeChatPluginMethods.SHARE_WEB_PAGE -> shareWebPage(call, result)
            WeChatPluginMethods.SHARE_FILE -> shareFile(call,result)
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
        miniProgramObj.miniprogramType = call.argument("miniProgramType") ?: 0// 正式版:0，测试版:1，体验版:2
        miniProgramObj.userName = call.argument("userName")     // 小程序原始id
        miniProgramObj.path = call.argument("path")            //小程序页面路径
        miniProgramObj.withShareTicket = call.argument("withShareTicket") ?: true
        val msg = WXMediaMessage(miniProgramObj)
        msg.title = call.argument(WechatPluginKeys.TITLE)                   // 小程序消息title
        msg.description = call.argument("description")               // 小程序消息desc
        val thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)

        GlobalScope.launch((Dispatchers.Main), CoroutineStart.DEFAULT) {
            if (thumbnail.isNullOrBlank()) {
                msg.thumbData = null
            } else {
                msg.thumbData = getThumbnailByteArrayMiniProgram(registrar, thumbnail)
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

        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val result = WeChatThumbnailUtil.thumbnailForMiniProgram(thumbnail, registrar)
            result ?: byteArrayOf()
        }.await()
    }

    private suspend fun getImageByteArrayCommon(registrar: PluginRegistry.Registrar?, imagePath: String): ByteArray {
        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val result = ShareImageUtil.getImageData(registrar, imagePath)
            result ?: byteArrayOf()
        }.await()
    }

    //    private suspend fun getThumbnailByteArrayCommon(registrar: PluginRegistry.Registrar?, thumbnail: String): ByteArray {
//        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT, {
//            val result = WeChatThumbnailUtil.thumbnailForCommon(thumbnail, registrar)
//            result ?: byteArrayOf()
//        }).await()
//    }
    private suspend fun getThumbnailByteArrayCommon(registrar: PluginRegistry.Registrar?, thumbnail: String): ByteArray {
        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val result = WeChatThumbnailUtil.thumbnailForCommon(thumbnail, registrar)
            result ?: byteArrayOf()
        }.await()
    }

    private suspend fun getThumbnailByteArray(imageData: ByteArray): ByteArray {
        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val bitmap = BitmapFactory.decodeByteArray(imageData, 0, imageData.size)
            val bmp = ThumbnailCompressUtil.createScaledBitmapWithRatio(bitmap, WeChatThumbnailUtil.SHARE_IMAGE_THUMB_LENGTH, false)
            if (bmp == null) {
                byteArrayOf()
            } else {
                ThumbnailCompressUtil.bmpToByteArray(bmp, Bitmap.CompressFormat.PNG, true)
            }
        }.await()
    }

    private fun shareImage(call: MethodCall, result: MethodChannel.Result) {
        val imagePath = call.argument<String>(WechatPluginKeys.IMAGE)
        val imageData: ByteArray? = call.argument(WechatPluginKeys.IMAGE_DATA)

        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
            val byteArray: ByteArray? = if (imagePath.isNullOrBlank()) {
                imageData ?: byteArrayOf()
            } else {
                getImageByteArrayCommon(registrar, imagePath)
            }


            val imgObj = if (byteArray != null && byteArray.isNotEmpty()) {

                if (byteArray.size > 512 * 1024) {
                    val input = ByteArrayInputStream(byteArray)

                    val suffix = when {
                        imagePath.isNullOrBlank() -> ".jpeg"
                        imagePath.lastIndexOf(".") == -1 -> ".jpeg"
                        else -> imagePath.substring(imagePath.lastIndexOf("."))
                    }

                    val file = ShareImageUtil.inputStreamToFile(input, suffix, registrar!!.context())
                    WXImageObject().apply {
                        setImagePath(file.absolutePath)
                    }
                } else {
                    WXImageObject(byteArray)
                }

            } else {
                null
            }

            if (imgObj == null) {
                result.error(CallResult.RESULT_FILE_NOT_EXIST, CallResult.RESULT_FILE_NOT_EXIST, imagePath)
                return@launch
            }

            var thumbnail: String? = call.argument(WechatPluginKeys.THUMBNAIL)

            val thumbnailData = if (thumbnail.isNullOrBlank() && imageData != null) {
                getThumbnailByteArray(imageData)
            } else {
                if (thumbnail.isNullOrBlank()) {
                    thumbnail = imagePath
                }
                getThumbnailByteArrayCommon(registrar, thumbnail!!)
            }


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

        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
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

        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
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
        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
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

    private fun shareFile(call:MethodCall,result:MethodChannel.Result){
        val file = WXFileObject()
        val filePath:String? = call.argument("filePath")
        file.filePath = filePath

        val msg = WXMediaMessage()
        msg.mediaObject = file
        msg.title = call.argument("title")
        msg.description = call.argument("description")
        val thumbnail: String? = call.argument("thumbnail")

        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
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
        req.scene = getScene(call.argument(WechatPluginKeys.SCENE)
                ?: WechatPluginKeys.SCENE_SESSION)
    }

}