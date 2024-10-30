package com.jarvan.fluwx.handlers

import android.content.Context
import android.content.Intent
import android.content.res.AssetFileDescriptor
import android.net.Uri
import androidx.core.content.FileProvider
import com.jarvan.fluwx.io.*
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelmsg.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.File
import java.io.IOException
import java.util.*
import kotlin.coroutines.CoroutineContext


/***
 * Created by mo on 2020/3/6
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
internal class FluwxShareHandlerEmbedding(
    private val flutterAssets: FlutterPlugin.FlutterAssets,
    override val context: Context
) : FluwxShareHandler {
    override val assetFileDescriptor: (String) -> AssetFileDescriptor = {
        val uri = Uri.parse(it)
        val packageName = uri.getQueryParameter("package")
        val subPath = if (packageName.isNullOrBlank()) {
            flutterAssets.getAssetFilePathBySubpath(uri.path.orEmpty())
        } else {
            flutterAssets.getAssetFilePathBySubpath(uri.path.orEmpty(), packageName)
        }
        context.assets.openFd(subPath)
    }

    override val job: Job = Job()

}

internal interface FluwxShareHandler : CoroutineScope {
    companion object {
        const val SHARE_IMAGE_THUMB_LENGTH = 32 * 1024
        const val SHARE_MINI_PROGRAM_THUMB_LENGTH = 120 * 1024
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
        val textObj = WXTextObject(call.argument("source"))
        val msg = WXMediaMessage()
        msg.mediaObject = textObj
        val req = SendMessageToWX.Req()
        setCommonArguments(call, req, msg)
        req.message = msg
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
            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            sendRequestInMain(result, req)
        }
    }

    private fun shareImage(call: MethodCall, result: MethodChannel.Result) {
        launch {
            val map: Map<String, Any> = call.argument("source") ?: mapOf()

            val imgHash = call.argument<String?>("imgDataHash")
            val localImagePath = map["localImagePath"] as? String
            val imageObject = localImagePath?.let {
                WXImageObject().apply {
                    if (supportFileProvider && targetHigherThanN) {
                        if (localImagePath.startsWith("content://")) {
                            imagePath = localImagePath
                        } else {
                            val tempFile = File(localImagePath)
                            val ecd = context.externalCacheDir ?: return@apply
                            val desPath =
                                ecd.absolutePath + File.separator + cachePathName
                            if (tempFile.exists()) {
                                val target = if (isFileInDirectory(
                                        file = tempFile,
                                        directory = File(desPath)
                                    )
                                ) {
                                    tempFile
                                } else {
                                    withContext(Dispatchers.IO) {
                                        copyFile(tempFile.absolutePath, desPath)
                                    }
                                }

                                imagePath = getFileContentUri(target)
                            }
                        }
                    } else {
                        imagePath = localImagePath
                    }

                    imgDataHash = imgHash
                }
            } ?: run {
                WXImageObject().apply {
                    val uint8List = map["uint8List"] as? ByteArray
                    uint8List?.let {
                        imageData = it
                        imgDataHash = imgHash
                    }
                }
            }


            val msg = WXMediaMessage()
            msg.mediaObject = imageObject

            msg.description = call.argument(keyDescription)

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
        msg.description = call.argument(keyDescription)

        launch {
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
        msg.description = call.argument(keyDescription)

        launch {
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
        msg.description = call.argument(keyDescription)

        launch {
            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            sendRequestInMain(result, req)
        }
    }

    private fun shareFile(call: MethodCall, result: MethodChannel.Result) {
        launch {

            val wxFileObject = WXFileObject()
//            val filePath: String? = call.argument("filePath")
//            wxFileObject.filePath = filePath

            val msg = WXMediaMessage()
            msg.mediaObject = wxFileObject
            msg.description = call.argument("description")

            val map: Map<String, Any> = call.argument("source") ?: mapOf()
            val sourceFile = WeChatFile.createWeChatFile(map, assetFileDescriptor)

            val sourceByteArray = sourceFile.readByteArray()

            wxFileObject.apply {
                if (supportFileProvider && targetHigherThanN) {
                    setFilePath(
                        getFileContentUri(
                            sourceByteArray.toCacheFile(
                                context,
                                sourceFile.suffix
                            )
                        )
                    )
                } else {
                    filePath = sourceByteArray.toExternalCacheFile(
                        context,
                        sourceFile.suffix
                    )?.absolutePath
                }
            }

            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            sendRequestInMain(result, req)
        }
    }

    private suspend fun sendRequestInMain(result: MethodChannel.Result, request: BaseReq) =
        withContext(Dispatchers.Main) {
            result.success(WXAPiHandler.wxApi?.sendReq(request))
        }

    private suspend fun compressThumbnail(ioIml: ImagesIO, length: Int) =
        ioIml.compressedByteArray(context, length)

    //    SESSION, TIMELINE, FAVORITE
    private fun setCommonArguments(
        call: MethodCall,
        req: SendMessageToWX.Req,
        msg: WXMediaMessage
    ) {
        msg.messageAction = call.argument("messageAction")
        call.argument<String?>("msgSignature")?.let {
            msg.msgSignature = it
        }
        call.argument<ByteArray?>("thumbData")?.let {
            msg.thumbData = it
        }

        call.argument<String?>("thumbDataHash")?.let {
            msg.thumbDataHash = it
        }

        msg.messageExt = call.argument("messageExt")
        msg.mediaTagName = call.argument("mediaTagName")
        msg.title = call.argument(keyTitle)
        msg.description = call.argument(keyDescription)
        req.transaction = UUID.randomUUID().toString().replace("-", "")
        val sceneIndex = call.argument<Int?>("scene")
        req.scene = when (sceneIndex) {
            0 -> SendMessageToWX.Req.WXSceneSession
            1 -> SendMessageToWX.Req.WXSceneTimeline
            2 -> SendMessageToWX.Req.WXSceneFavorite
            else -> SendMessageToWX.Req.WXSceneSession
        }
    }

    private fun getFileContentUri(file: File?): String? {
        if (file == null || !file.exists())
            return null

        val contentUri = FileProvider.getUriForFile(
            context,
            "${context.packageName}.fluwxprovider",  // 要与`AndroidManifest.xml`里配置的`authorities`一致，假设你的应用包名为com.example.app
            file
        )

        // 授权给微信访问路径
        context.grantUriPermission(
            "com.tencent.mm",  // 这里填微信包名
            contentUri, Intent.FLAG_GRANT_READ_URI_PERMISSION
        )

        return contentUri.toString() // contentUri.toString() 即是以"content://"开头的用于共享的路径

    }

    private val supportFileProvider: Boolean
        get() = (WXAPiHandler.wxApi?.wxAppSupportAPI ?: 0) >= 0x27000D00
    private val targetHigherThanN: Boolean get() = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N

    val context: Context

    val assetFileDescriptor: (String) -> AssetFileDescriptor

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + job

    val job: Job

    fun onDestroy() = job.cancel()
}

private fun isFileInDirectory(file: File, directory: File): Boolean {
    return try {
        val filePath = file.canonicalPath
        val dirPath = directory.canonicalPath
        filePath.startsWith(dirPath)
    } catch (e: IOException) {
        false
    }
}