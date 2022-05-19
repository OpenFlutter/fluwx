package com.jarvan.fluwx

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import com.jarvan.fluwx.handlers.*
import com.jarvan.fluwx.utils.WXApiUtils
import com.tencent.mm.opensdk.modelbiz.*
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
class FluwxPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.NewIntentListener {
    companion object {
        var callingChannel: MethodChannel? = null

        // 主动获取的启动参数
        var extMsg: String? = null
    }

    private var shareHandler: FluwxShareHandler? = null

    private var authHandler: FluwxAuthHandler? = null

    private var fluwxChannel: MethodChannel? = null

    private var context: Context? = null

    private fun handelIntent(intent: Intent) {
        val action = intent.action
        val dataString = intent.dataString
        if (Intent.ACTION_VIEW == action) {
            extMsg = dataString
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.jarvanmo/fluwx")
        channel.setMethodCallHandler(this)
        fluwxChannel = channel
        context = flutterPluginBinding.applicationContext
        authHandler = FluwxAuthHandler(channel)
        shareHandler = FluwxShareHandlerEmbedding(
            flutterPluginBinding.flutterAssets,
            flutterPluginBinding.applicationContext
        )
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        callingChannel = fluwxChannel
        when {
            call.method == "registerApp" -> WXAPiHandler.registerApp(call, result, context)
            call.method == "startLog" -> WXAPiHandler.startLog(call, result)
            call.method == "stopLog" -> WXAPiHandler.stopLog(call, result)
            call.method == "sendAuth" -> authHandler?.sendAuth(call, result)
            call.method == "authByQRCode" -> authHandler?.authByQRCode(call, result)
            call.method == "stopAuthByQRCode" -> authHandler?.stopAuthByQRCode(result)
            call.method == "payWithFluwx" -> pay(call, result)
            call.method == "payWithHongKongWallet" -> payWithHongKongWallet(call, result)
            call.method == "launchMiniProgram" -> launchMiniProgram(call, result)
            call.method == "subscribeMsg" -> subScribeMsg(call, result)
            call.method == "autoDeduct" -> signAutoDeduct(call, result)
            call.method == "autoDeductV2" -> autoDeductV2(call, result)
            call.method == "openWXApp" -> openWXApp(result)
            call.method.startsWith("share") -> shareHandler?.share(call, result)
            call.method == "isWeChatInstalled" -> WXAPiHandler.checkWeChatInstallation(result)
            call.method == "getExtMsg" -> getExtMsg(result)
            call.method == "openWeChatCustomerServiceChat" -> openWeChatCustomerServiceChat(
                call,
                result
            )
            call.method == "checkSupportOpenBusinessView" -> WXAPiHandler.checkSupportOpenBusinessView(
                result
            )
            call.method == "openBusinessView" -> openBusinessView(call, result)

            call.method == "openWeChatInvoice" -> openWeChatInvoice(call, result);
            else -> result.notImplemented()
        }
    }

    private fun openWeChatInvoice(call: MethodCall, result: Result) {
        if (WXAPiHandler.wxApi == null) {
            result.error("Unassigned WxApi", "please config wxapi first", null)
            return
        } else {
            //android 只有ChooseCard, IOS直接有ChooseInvoice
            val request = ChooseCardFromWXCardPackage.Req()
            request.cardType = call.argument("cardType")
            request.appId = call.argument("appId")
            request.locationId = call.argument("locationId")
            request.cardId = call.argument("cardId")
            request.canMultiSelect = call.argument("canMultiSelect")

            request.timeStamp = System.currentTimeMillis().toString()
            request.nonceStr = System.currentTimeMillis().toString()
            request.signType = "SHA1"
            request.cardSign = WXApiUtils.createSign(request.appId, request.nonceStr, request.timeStamp, request.cardType)
            val done = WXAPiHandler.wxApi?.sendReq(request)
            result.success(done)
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
        handelIntent(binding.activity.intent)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//        WXAPiHandler.setContext(binding.activity.applicationContext)
        handelIntent(binding.activity.intent)
        shareHandler?.permissionHandler = PermissionHandler(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }


    private fun getExtMsg(result: Result) {
        result.success(extMsg)
        extMsg = null
    }

    private fun pay(call: MethodCall, result: Result) {

        if (WXAPiHandler.wxApi == null) {
            result.error("Unassigned WxApi", "please config wxapi first", null)
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

    private fun payWithHongKongWallet(call: MethodCall, result: Result) {
        val prepayId = call.argument<String>("prepayId") ?: ""
        val request = WXOpenBusinessWebview.Req()
        request.businessType = 1
        request.queryInfo = hashMapOf(
            "token" to prepayId
        )
        result.success(WXAPiHandler.wxApi?.sendReq(request))
    }

    private fun openWeChatCustomerServiceChat(call: MethodCall, result: Result) {
        val url = call.argument<String>("url") ?: ""
        val corpId = call.argument<String>("corpId") ?: ""
        val request = WXOpenCustomerServiceChat.Req()
        request.corpId = corpId // 企业ID

        request.url = url
        result.success(WXAPiHandler.wxApi?.sendReq(request))
    }

    private fun openBusinessView(call: MethodCall, result: Result) {
        val request = WXOpenBusinessView.Req()
        request.businessType = call.argument<String>("businessType") ?: ""
        request.query = call.argument<String>("query") ?: ""
        request.extInfo = "{\"miniProgramType\": 0}"
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

    private fun autoDeductV2(call: MethodCall, result: Result) {
        val businessType = call.argument<Int>("businessType") ?: 12

        val req = WXOpenBusinessWebview.Req()
        req.businessType = businessType
        req.queryInfo = call.argument<HashMap<String, String>>("queryInfo") ?: hashMapOf()

        result.success(WXAPiHandler.wxApi?.sendReq(req))
    }

    private fun subScribeMsg(call: MethodCall, result: Result) {
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

    private fun launchMiniProgram(call: MethodCall, result: Result) {
        val req = WXLaunchMiniProgram.Req()
        req.userName = call.argument("userName") // 填小程序原始id
        req.path = call.argument<String?>("path") ?: "" //拉起小程序页面的可带参路径，不填默认拉起小程序首页
        val type = call.argument("miniProgramType") ?: 0
        req.miniprogramType = when (type) {
            1 -> WXLaunchMiniProgram.Req.MINIPROGRAM_TYPE_TEST
            2 -> WXLaunchMiniProgram.Req.MINIPROGRAM_TYPE_PREVIEW
            else -> WXLaunchMiniProgram.Req.MINIPTOGRAM_TYPE_RELEASE
        }// 可选打开 开发版，体验版和正式版
        val done = WXAPiHandler.wxApi?.sendReq(req)
        result.success(done)
    }

    private fun openWXApp(result: Result) = result.success(WXAPiHandler.wxApi?.openWXApp())

    override fun onNewIntent(intent: Intent): Boolean {
        handelIntent(intent)
        return false
    }
}
