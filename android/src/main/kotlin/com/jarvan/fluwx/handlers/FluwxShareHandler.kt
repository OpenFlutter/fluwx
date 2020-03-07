package com.jarvan.fluwx.handlers

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.jarvan.fluwx.io.ImagesIO
import com.jarvan.fluwx.io.ImagesIOIml
import com.jarvan.fluwx.io.WeChatImage
import com.jarvan.fluwx.io.toExternalCacheFile
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelmsg.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.util.*
import kotlin.coroutines.CoroutineContext

/***
 * Created by mo on 2020/3/6
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
internal class FluwxShareHandler(private val flutterAssets: FlutterPlugin.FlutterAssets, private val context: Context) : CoroutineScope {
    companion object {
        const val SHARE_IMAGE_THUMB_LENGTH = 32 * 1024
        private const val keyTitle = "title"
        private const val keyThumbnail = "thumbnail"
        private const val keyDescription = "description"
    }

    fun share(call: MethodCall, result: MethodChannel.Result) {
        if (WXAPiHandler.wxApi == null) {
            result.error("Unassigned WxApi", "please config  wxapi first", null)
            return
        }

        when (call.method) {
            "shareText" -> shareText(call, result)
            "shareMiniProgram" -> shareMiniProgram(call, result)
            "shareImage" -> shareImage(call, result)
            "shareMusic" -> shareMusic(call, result)
            "shareVideo" -> shareVideo(call, result)
            "shareWebPage" -> shareWebPage(call, result)
            "shareFile" -> shareFile(call, result)
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun shareText(call: MethodCall, result: MethodChannel.Result) {
        val textObj = WXTextObject()
        textObj.text = call.argument("source")
        val msg = WXMediaMessage()
        msg.mediaObject = textObj
        val req = SendMessageToWX.Req()
        req.message = msg

        setCommonArguments(call, req, msg)
        result.success(WXAPiHandler.wxApi?.sendReq(req))
    }

    private fun shareMiniProgram(call: MethodCall, result: MethodChannel.Result) {
        val miniProgramObj = WXMiniProgramObject()
        miniProgramObj.webpageUrl = call.argument("webPageUrl") // 兼容低版本的网页链接
        miniProgramObj.miniprogramType = call.argument("miniProgramType") ?: 0// 正式版:0，测试版:1，体验版:2
        miniProgramObj.userName = call.argument("userName")     // 小程序原始id
        miniProgramObj.path = call.argument("path")            //小程序页面路径
        miniProgramObj.withShareTicket = call.argument("withShareTicket") ?: true
        val msg = WXMediaMessage(miniProgramObj)
        msg.title = call.argument(keyTitle)                   // 小程序消息title
        msg.description = call.argument(keyDescription)               // 小程序消息desc

        launch {
            msg.thumbData = readThumbnailByteArray(call)

            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            sendRequestInMain(result, req)
        }
    }

    private fun shareImage(call: MethodCall, result: MethodChannel.Result) {
        launch {
            val sourceImage = WeChatImage.createWeChatImage(call.argument("source")
                    ?: mapOf(), flutterAssets, context)
            val thumbData = readThumbnailByteArray(call)

            val sourceByteArray = sourceImage.readByteArray()
            val imageObject = when {
                sourceByteArray.isEmpty() -> {
                    WXImageObject()
                }
                sourceByteArray.size > 512 * 1024 -> {
                    WXImageObject().apply {
                        if (ContextCompat.checkSelfPermission(context, Manifest.permission_group.STORAGE) == PackageManager.PERMISSION_GRANTED) {
                            setImagePath(sourceByteArray.toExternalCacheFile(context, sourceImage.suffix)?.absolutePath)
                        } else {
                            Fragment().requestPermissions(arrayOf(Manifest.permission_group.STORAGE), 12121)
                        }
                    }
                }
                else -> {
                    WXImageObject(sourceByteArray)
                }
            }
            val msg = WXMediaMessage()
            msg.mediaObject = imageObject
            msg.thumbData = thumbData

            msg.title = call.argument<String>(keyTitle)
            msg.description = call.argument<String>(keyDescription)

            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg

            sendRequestInMain(result, req)
        }
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
        msg.title = call.argument(keyTitle)
        msg.description = call.argument(keyDescription)

        launch {
            msg.thumbData = readThumbnailByteArray(call)

            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            sendRequestInMain(result, req)
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
        msg.title = call.argument(keyTitle)
        msg.description = call.argument(keyDescription)

        launch {
            msg.thumbData = readThumbnailByteArray(call)
            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg

            sendRequestInMain(result, req)
        }
    }

    private fun shareWebPage(call: MethodCall, result: MethodChannel.Result) {
        val webPage = WXWebpageObject()
        webPage.webpageUrl = call.argument("webPage")
        val msg = WXMediaMessage()

        msg.mediaObject = webPage
        msg.title = call.argument(keyTitle)
        msg.description = call.argument(keyDescription)

        launch {
            msg.thumbData = readThumbnailByteArray(call)
            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            sendRequestInMain(result, req)
        }
    }

    private fun shareFile(call: MethodCall, result: MethodChannel.Result) {
        val file = WXFileObject()
        val filePath: String? = call.argument("filePath")
        file.filePath = filePath

        val msg = WXMediaMessage()
        msg.mediaObject = file
        msg.title = call.argument("title")
        msg.description = call.argument("description")

        launch {
            msg.thumbData = readThumbnailByteArray(call)
            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            sendRequestInMain(result, req)
        }
    }

    private suspend fun sendRequestInMain(result: MethodChannel.Result, request: BaseReq) = withContext(Dispatchers.Main) {
        result.success(WXAPiHandler.wxApi?.sendReq(request))
    }

    private suspend fun readThumbnailByteArray(call: MethodCall): ByteArray? {
        val thumbnailMap: Map<String, Any>? = call.argument(keyThumbnail)
        return thumbnailMap?.run {
            val thumbnailImage = WeChatImage.createWeChatImage(thumbnailMap, flutterAssets, context)
            val thumbnailImageIO = ImagesIOIml(thumbnailImage)
            compressThumbnail(thumbnailImageIO)
        }
    }

    private suspend fun compressThumbnail(ioIml: ImagesIO) = ioIml.compressedByteArray(context, SHARE_IMAGE_THUMB_LENGTH)
    //    SESSION, TIMELINE, FAVORITE
    private fun setCommonArguments(call: MethodCall, req: SendMessageToWX.Req, msg: WXMediaMessage) {
        msg.messageAction = call.argument<String?>("messageAction")
        msg.messageExt = call.argument<String?>("messageExt")
        msg.mediaTagName = call.argument<String?>("mediaTagName")
        req.transaction = UUID.randomUUID().toString().replace("-", "")
        val sceneIndex = call.argument<Int?>("scene")
        req.scene = when (sceneIndex) {
            0 -> SendMessageToWX.Req.WXSceneSession
            1 -> SendMessageToWX.Req.WXSceneTimeline
            2 -> SendMessageToWX.Req.WXSceneFavorite
            else -> SendMessageToWX.Req.WXSceneSession
        }
    }

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + job

    private val job = Job()

    fun onDestroy() {
        job.cancel()
    }
}