package com.jarvan.fluwx.handlers

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.AssetFileDescriptor
import android.net.Uri
import android.text.TextUtils
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import com.jarvan.fluwx.io.*
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelmsg.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.*
import java.io.File
import java.util.*
import kotlin.coroutines.CoroutineContext


/***
 * Created by mo on 2020/3/6
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
internal class FluwxShareHandlerEmbedding(private val flutterAssets: FlutterPlugin.FlutterAssets, override val context: Context) : FluwxShareHandler {
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

    override var permissionHandler: PermissionHandler? = null
}

internal class FluwxShareHandlerCompat(private val registrar: PluginRegistry.Registrar) : FluwxShareHandler {
    override val assetFileDescriptor: (String) -> AssetFileDescriptor = {
        val uri = Uri.parse(it)
        val packageName = uri.getQueryParameter("package")
        val key = if (TextUtils.isEmpty(packageName)) {
            registrar.lookupKeyForAsset(uri.path)
        } else {
            registrar.lookupKeyForAsset(uri.path, packageName)
        }
        context.assets.openFd(key)
    }

    override val context: Context = registrar.context().applicationContext
    override val job: Job = Job()
    override var permissionHandler: PermissionHandler? = null
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
            msg.thumbData = readThumbnailByteArray(call, length = SHARE_MINI_PROGRAM_THUMB_LENGTH)

            val req = SendMessageToWX.Req()
            setCommonArguments(call, req, msg)
            req.message = msg
            sendRequestInMain(result, req)
        }
    }

    private fun shareImage(call: MethodCall, result: MethodChannel.Result) {
        launch {
            val map: Map<String, Any> = call.argument("source") ?: mapOf()
            val sourceImage = WeChatFile.createWeChatFile(map, assetFileDescriptor)
            val thumbData = readThumbnailByteArray(call)

            val sourceByteArray = sourceImage.readByteArray()
            val imageObject = when {
                sourceByteArray.isEmpty() -> {
                    WXImageObject()
                }
                sourceByteArray.size > 500 * 1024 -> {
                    WXImageObject().apply {
                        if (supportFileProvider && targetHigherThanN) {
                            setImagePath(getFileContentUri(sourceByteArray.toCacheFile(context, sourceImage.suffix)))
                        } else {
                            if (ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                                setImagePath(sourceByteArray.toExternalCacheFile(context, sourceImage.suffix)?.absolutePath)
                            } else {
                                permissionHandler?.requestStoragePermission()
                            }
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
//            if (supportFileProvider && targetHigherThanN) {
//                wxFileObject.filePath = getFileContentUri(sourceByteArray.toCacheFile(context, sourceFile.suffix))
//            } else {
                if (ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                    wxFileObject.filePath = sourceByteArray.toExternalCacheFile(context, sourceFile.suffix)?.absolutePath
                } else {
                    permissionHandler?.requestStoragePermission()
                }
//            }

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

    private suspend fun readThumbnailByteArray(call: MethodCall, length: Int = SHARE_IMAGE_THUMB_LENGTH): ByteArray? {
        val thumbnailMap: Map<String, Any>? = call.argument(keyThumbnail)
        return thumbnailMap?.run {
            val thumbnailImage = WeChatFile.createWeChatFile(thumbnailMap, assetFileDescriptor)
            val thumbnailImageIO = ImagesIOIml(thumbnailImage)
            compressThumbnail(thumbnailImageIO, length)
        }
    }

    private suspend fun compressThumbnail(ioIml: ImagesIO, length: Int) = ioIml.compressedByteArray(context, length)

    //    SESSION, TIMELINE, FAVORITE
    private fun setCommonArguments(call: MethodCall, req: SendMessageToWX.Req, msg: WXMediaMessage) {
        msg.messageAction = call.argument("messageAction")
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

        val contentUri = FileProvider.getUriForFile(context,
                "${context.packageName}.fluwxprovider",  // 要与`AndroidManifest.xml`里配置的`authorities`一致，假设你的应用包名为com.example.app
                file)

        // 授权给微信访问路径
        context.grantUriPermission("com.tencent.mm",  // 这里填微信包名
                contentUri, Intent.FLAG_GRANT_READ_URI_PERMISSION)

        return contentUri.toString() // contentUri.toString() 即是以"content://"开头的用于共享的路径

    }

    private val supportFileProvider: Boolean get() = WXAPiHandler.wxApi?.wxAppSupportAPI ?: 0 >= 0x27000D00
    private val targetHigherThanN: Boolean get() = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N

    val context: Context

    val assetFileDescriptor: (String) -> AssetFileDescriptor

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + job

    val job: Job

    var permissionHandler: PermissionHandler?

    fun onDestroy() = job.cancel()
}

