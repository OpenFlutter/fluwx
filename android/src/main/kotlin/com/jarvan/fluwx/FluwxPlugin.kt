package com.jarvan.fluwx

import androidx.annotation.NonNull
import com.jarvan.fluwx.handlers.*
import com.tencent.mm.opensdk.modelbiz.SubscribeMessage
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram
import com.tencent.mm.opensdk.modelbiz.WXOpenBusinessWebview
import com.tencent.mm.opensdk.modelpay.PayReq
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** FluwxPlugin */
class FluwxPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    companion object {

        var callingChannel:MethodChannel? = null

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val channel = MethodChannel(registrar.messenger(), "com.jarvanmo/fluwx")
            val authHandler = FluwxAuthHandler(channel)
            WXAPiHandler.setContext(registrar.activity().applicationContext)
            channel.setMethodCallHandler(FluwxPlugin().apply {
                this.fluwxChannel = channel
                this.authHandler = authHandler
                this.shareHandler = FluwxShareHandlerCompat(registrar).apply {
                    permissionHandler = PermissionHandler(registrar.activity())
                }
            })
        }
    }

    private var shareHandler: FluwxShareHandler? = null

    private var authHandler: FluwxAuthHandler? = null

    private var fluwxChannel: MethodChannel? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.jarvanmo/fluwx")
        channel.setMethodCallHandler(this)
        fluwxChannel = channel
        authHandler = FluwxAuthHandler(channel)
        shareHandler = FluwxShareHandlerEmbedding(flutterPluginBinding.flutterAssets, flutterPluginBinding.applicationContext)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        FluwxPlugin.callingChannel = fluwxChannel
        when {
            call.method == "registerApp" -> WXAPiHandler.registerApp(call, result)
            call.method == "sendAuth" -> authHandler?.sendAuth(call, result)
            call.method == "authByQRCode" -> authHandler?.authByQRCode(call, result)
            call.method == "stopAuthByQRCode" -> authHandler?.stopAuthByQRCode(result)
            call.method == "payWithFluwx" -> pay(call, result)
            call.method == "payWithHongKongWallet" -> payWithHongKongWallet(call, result)
            call.method == "launchMiniProgram" -> launchMiniProgram(call, result)
            call.method == "subscribeMsg" -> subScribeMsg(call, result)
            call.method == "autoDeduct" -> signAutoDeduct(call, result)
            call.method == "openWXApp" -> openWXApp(result)
            call.method.startsWith("share") -> shareHandler?.share(call, result)
            call.method == "isWeChatInstalled" -> WXAPiHandler.checkWeChatInstallation(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        shareHandler?.onDestroy()
        authHandler?.removeAllListeners()
    }

    override fun onDetachedFromActivity() {
        shareHandler?.permissionHandler = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        shareHandler?.permissionHandler = PermissionHandler(binding.activity)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        WXAPiHandler.setContext(binding.activity.applicationContext)
        shareHandler?.permissionHandler = PermissionHandler(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }


    private fun pay(call: MethodCall, result: MethodChannel.Result) {

        if (WXAPiHandler.wxApi == null) {
            result.error("Unassigned WxApi", "please config  wxapi first", null)
            return
        } else {

// 将该app注册到微信
            val request = PayReq()
            request.appId = call.argument("appId")
            request.partnerId = call.argument("partnerId")
            request.prepayId = call.argument("prepayId")
            request.packageValue = call.argument("packageValue")
            request.nonceStr = call.argument("nonceStr")
            request.timeStamp = call.argument<Long>("timeStamp").toString()
            request.sign = call.argument("sign")
            request.signType = call.argument("signType")
            request.extData = call.argument("extData")
            val done = WXAPiHandler.wxApi?.sendReq(request)
            result.success(done)
        }
    }

    private fun payWithHongKongWallet(call: MethodCall, result: MethodChannel.Result) {
        val prepayId = call.argument<String>("prepayId") ?: ""
        val request = WXOpenBusinessWebview.Req()
        request.businessType = 1
        request.queryInfo = hashMapOf(
                "token" to prepayId
        )
        result.success(WXAPiHandler.wxApi?.sendReq(request))
    }

    private fun signAutoDeduct(call: MethodCall, result: Result) {
        val appId: String = call.argument<String>("appid") ?: ""
        val mchId = call.argument<String>("mch_id") ?: ""
        val planId = call.argument<String>("plan_id") ?: ""
        val contractCode = call.argument<String>("contract_code") ?: ""
        val requestSerial = call.argument<String>("request_serial") ?: ""
        val contractDisplayAccount = call.argument<String>("contract_display_account") ?: ""
        val notifyUrl = call.argument<String>("notify_url") ?: ""
        val version = call.argument<String>("version") ?: ""
        val sign = call.argument<String>("sign") ?: ""
        val timestamp = call.argument<String>("timestamp") ?: ""
        val returnApp = call.argument<String>("return_app") ?: ""
        val businessType = call.argument<Int>("businessType") ?: 12

        val req = WXOpenBusinessWebview.Req()
        req.businessType = businessType
        req.queryInfo = hashMapOf(
                "appid" to appId,
                "mch_id" to mchId,
                "plan_id" to planId,
                "contract_code" to contractCode,
                "request_serial" to requestSerial,
                "contract_display_account" to contractDisplayAccount,
                "notify_url" to notifyUrl,
                "version" to version,
                "sign" to sign,
                "timestamp" to timestamp,
                "return_app" to returnApp
        )
        result.success(WXAPiHandler.wxApi?.sendReq(req))
    }

    private fun subScribeMsg(call: MethodCall, result: MethodChannel.Result) {
        val appId = call.argument<String>("appId")
        val scene = call.argument<Int>("scene")
        val templateId = call.argument<String>("templateId")
        val reserved = call.argument<String>("reserved")

        val req = SubscribeMessage.Req()
        req.openId = appId
        req.scene = scene!!
        req.reserved = reserved
        req.templateID = templateId
        val b = WXAPiHandler.wxApi?.sendReq(req)
        result.success(b)
    }

    private fun launchMiniProgram(call: MethodCall, result: MethodChannel.Result) {
        val req = WXLaunchMiniProgram.Req()
        req.userName = call.argument<String?>("userName") // 填小程序原始id
        req.path = call.argument<String?>("path") ?: "" //拉起小程序页面的可带参路径，不填默认拉起小程序首页
        val type = call.argument("miniProgramType") ?: 0
        req.miniprogramType = when (type) {
            1 -> WXLaunchMiniProgram.Req.MINIPROGRAM_TYPE_TEST
            2 -> WXLaunchMiniProgram.Req.MINIPROGRAM_TYPE_PREVIEW
            else -> WXLaunchMiniProgram.Req.MINIPTOGRAM_TYPE_RELEASE
        }// 可选打开 开发版，体验版和正式版
        val done = WXAPiHandler.wxApi?.sendReq(req)
        result.success(WXAPiHandler.wxApi?.sendReq(req))
    }

    private fun openWXApp(result: MethodChannel.Result) = result.success(WXAPiHandler.wxApi?.openWXApp())
}
