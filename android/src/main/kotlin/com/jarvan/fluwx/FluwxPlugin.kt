package com.jarvan.fluwx

import android.content.Context
import android.content.Intent
import com.jarvan.fluwx.handlers.FluwxAuthHandler
import com.jarvan.fluwx.handlers.FluwxRequestHandler
import com.jarvan.fluwx.handlers.FluwxShareHandler
import com.jarvan.fluwx.handlers.FluwxShareHandlerEmbedding
import com.jarvan.fluwx.handlers.PermissionHandler
import com.jarvan.fluwx.handlers.WXAPiHandler
import com.jarvan.fluwx.utils.WXApiUtils
import com.jarvan.fluwx.utils.readWeChatCallbackIntent
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelbiz.ChooseCardFromWXCardPackage
import com.tencent.mm.opensdk.modelbiz.OpenRankList
import com.tencent.mm.opensdk.modelbiz.OpenWebview
import com.tencent.mm.opensdk.modelbiz.SubscribeMessage
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram
import com.tencent.mm.opensdk.modelbiz.WXOpenBusinessView
import com.tencent.mm.opensdk.modelbiz.WXOpenBusinessWebview
import com.tencent.mm.opensdk.modelbiz.WXOpenCustomerServiceChat
import com.tencent.mm.opensdk.modelmsg.LaunchFromWX
import com.tencent.mm.opensdk.modelmsg.SendAuth
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.tencent.mm.opensdk.modelmsg.ShowMessageFromWX
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.modelpay.PayResp
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler
import com.tencent.mm.opensdk.openapi.SendReqCallback
import com.tencent.mm.opensdk.utils.ILog
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.util.concurrent.atomic.AtomicBoolean


/** FluwxPlugin */
class FluwxPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.NewIntentListener, IWXAPIEventHandler {
    companion object {
        // 主动获取的启动参数
        var extMsg: String? = null
    }

    private val errStr = "errStr"
    private val errCode = "errCode"
    private val openId = "openId"
    private val type = "type"

    private val weChatLogger = object : ILog {

        override fun d(p0: String?, p1: String?) {
            logToFlutter(p0, p1)
        }

        override fun i(p0: String?, p1: String?) {
            logToFlutter(p0, p1)
        }

        override fun e(p0: String?, p1: String?) {
            logToFlutter(p0, p1)
        }

        override fun v(p0: String?, p1: String?) {
            logToFlutter(p0, p1)
        }

        override fun w(p0: String?, p1: String?) {
            logToFlutter(p0, p1)
        }
    }
    private var shareHandler: FluwxShareHandler? = null

    private var authHandler: FluwxAuthHandler? = null

    private var fluwxChannel: MethodChannel? = null

    private var context: Context? = null
    private val attemptToResumeMsgFromWxFlag = AtomicBoolean(false)

    private var activityPluginBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.jarvanmo/fluwx")
        channel.setMethodCallHandler(this)
        fluwxChannel = channel
        context = flutterPluginBinding.applicationContext
        authHandler = FluwxAuthHandler(channel)
        shareHandler = FluwxShareHandlerEmbedding(
            flutterPluginBinding.flutterAssets, flutterPluginBinding.applicationContext
        )
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "registerApp" -> {
                WXAPiHandler.registerApp(call, result, context)
                if (FluwxConfigurations.enableLogging) {
                    WXAPiHandler.wxApi?.setLogImpl(weChatLogger)
                }
            }

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
                call, result
            )

            call.method == "checkSupportOpenBusinessView" -> WXAPiHandler.checkSupportOpenBusinessView(
                result
            )

            call.method == "openBusinessView" -> openBusinessView(call, result)

            call.method == "openWeChatInvoice" -> openWeChatInvoice(call, result)
            call.method == "openUrl" -> openUrl(call, result)
            call.method == "openRankList" -> openRankList(result)
            call.method == "attemptToResumeMsgFromWx" -> attemptToResumeMsgFromWx(result)
            call.method == "selfCheck" -> result.success(null)
            else -> result.notImplemented()
        }
    }

    private fun attemptToResumeMsgFromWx(result: Result) {
        if (attemptToResumeMsgFromWxFlag.compareAndSet(false, true)) {
            activityPluginBinding?.activity?.intent?.let {
                letWeChatHandleIntent(it)
            }

        }
        result.success(null)
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
            request.cardSign = WXApiUtils.createSign(
                request.appId, request.nonceStr, request.timeStamp, request.cardType
            )
            val done = WXAPiHandler.wxApi?.sendReq(request)
            result.success(done)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        shareHandler?.onDestroy()
        authHandler?.removeAllListeners()
        activityPluginBinding = null
    }

    override fun onDetachedFromActivity() {
        shareHandler?.permissionHandler = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        shareHandler?.permissionHandler = PermissionHandler(binding.activity)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//        WXAPiHandler.setContext(binding.activity.applicationContext)
        activityPluginBinding = binding
        binding.addOnNewIntentListener(this)
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

    private fun openUrl(call: MethodCall, result: Result) {
        val req = OpenWebview.Req()
        req.url = call.argument("url")
        WXAPiHandler.wxApi?.sendReq(req, SendReqCallback {
            result.success(it)
        }) ?: kotlin.run {
            result.success(false)
        }
    }

    private fun openRankList(result: Result) {
        val req = OpenRankList.Req()
        WXAPiHandler.wxApi?.sendReq(req, SendReqCallback {
            result.success(it)
        }) ?: kotlin.run {
            result.success(false)
        }
    }

    override fun onNewIntent(intent: Intent): Boolean {
        return letWeChatHandleIntent(intent)
    }

    private fun letWeChatHandleIntent(intent: Intent): Boolean =
        intent.readWeChatCallbackIntent()?.let {
            WXAPiHandler.wxApi?.handleIntent(it, this) ?: false
        } ?: run {
            false
        }

    override fun onReq(req: BaseReq?) {
        activityPluginBinding?.activity?.let { activity ->
            req?.let {
                if (FluwxConfigurations.interruptWeChatRequestByFluwx) {
                    when (req) {
                        is ShowMessageFromWX.Req -> handleShowMessageFromWX(req)
                        is LaunchFromWX.Req -> handleLaunchFromWX(req)
                        else -> {}
                    }
                } else {
                    FluwxRequestHandler.customOnReqDelegate?.invoke(req, activity)
                }
            }
        }
    }


    private fun handleShowMessageFromWX(req: ShowMessageFromWX.Req) {
        val result = mapOf(
            "extMsg" to req.message.messageExt,
            "messageAction" to req.message.messageAction,
            "description" to req.message.description,
            "lang" to req.lang,
            "description" to req.country,
        )

        extMsg = req.message.messageExt
        fluwxChannel?.invokeMethod("onWXShowMessageFromWX", result)
    }

    private fun handleLaunchFromWX(req: LaunchFromWX.Req) {
        val result = mapOf(
            "extMsg" to req.messageExt,
            "messageAction" to req.messageAction,
            "lang" to req.lang,
            "country" to req.country,
        )
        extMsg = req.messageExt

        fluwxChannel?.invokeMethod("onWXLaunchFromWX", result)
    }

    override fun onResp(response: BaseResp?) {
        when (response) {
            is SendAuth.Resp -> handleAuthResponse(response)
            is SendMessageToWX.Resp -> handleSendMessageResp(response)
            is PayResp -> handlePayResp(response)
            is WXLaunchMiniProgram.Resp -> handleLaunchMiniProgramResponse(response)
            is SubscribeMessage.Resp -> handleSubscribeMessage(response)
            is WXOpenBusinessWebview.Resp -> handlerWXOpenBusinessWebviewResponse(response)
            is WXOpenCustomerServiceChat.Resp -> handlerWXOpenCustomerServiceChatResponse(response)
            is WXOpenBusinessView.Resp -> handleWXOpenBusinessView(response)
            is ChooseCardFromWXCardPackage.Resp -> handleWXOpenInvoiceResponse(response)
            else -> {}
        }
    }

    private fun handleWXOpenInvoiceResponse(response: ChooseCardFromWXCardPackage.Resp) {
        val result = mapOf(
            "cardItemList" to response.cardItemList,
            "transaction" to response.transaction,
            "openid" to response.openId,
            errStr to response.errStr,
            type to response.type,
            errCode to response.errCode
        )

        fluwxChannel?.invokeMethod("onOpenWechatInvoiceResponse", result)
    }

    private fun handleWXOpenBusinessView(response: WXOpenBusinessView.Resp) {
        val result = mapOf(
            "openid" to response.openId,
            "extMsg" to response.extMsg,
            "businessType" to response.businessType,
            errStr to response.errStr,
            type to response.type,
            errCode to response.errCode
        )

        fluwxChannel?.invokeMethod("onOpenBusinessViewResponse", result)
    }

    private fun handleSubscribeMessage(response: SubscribeMessage.Resp) {
        val result = mapOf(
            "openid" to response.openId,
            "templateId" to response.templateID,
            "action" to response.action,
            "reserved" to response.reserved,
            "scene" to response.scene,
            type to response.type
        )

        fluwxChannel?.invokeMethod("onSubscribeMsgResp", result)
    }

    private fun handleLaunchMiniProgramResponse(response: WXLaunchMiniProgram.Resp) {
        val result = mutableMapOf(
            errStr to response.errStr,
            type to response.type,
            errCode to response.errCode,
            openId to response.openId
        )

        response.extMsg?.let {
            result["extMsg"] = response.extMsg
        }

        fluwxChannel?.invokeMethod("onLaunchMiniProgramResponse", result)
    }

    private fun handlePayResp(response: PayResp) {
        val result = mapOf(
            "prepayId" to response.prepayId,
            "returnKey" to response.returnKey,
            "extData" to response.extData,
            errStr to response.errStr,
            type to response.type,
            errCode to response.errCode
        )
        fluwxChannel?.invokeMethod("onPayResponse", result)
    }

    private fun handleSendMessageResp(response: SendMessageToWX.Resp) {
        val result = mapOf(
            errStr to response.errStr,
            type to response.type,
            errCode to response.errCode,
            openId to response.openId
        )

        fluwxChannel?.invokeMethod("onShareResponse", result)
    }

    private fun handleAuthResponse(response: SendAuth.Resp) {
        val result = mapOf(
            errCode to response.errCode,
            "code" to response.code,
            "state" to response.state,
            "lang" to response.lang,
            "country" to response.country,
            errStr to response.errStr,
            openId to response.openId,
            "url" to response.url,
            type to response.type
        )

        fluwxChannel?.invokeMethod("onAuthResponse", result)
    }


    private fun handlerWXOpenBusinessWebviewResponse(response: WXOpenBusinessWebview.Resp) {
        val result = mapOf(
            errCode to response.errCode,
            "businessType" to response.businessType,
            "resultInfo" to response.resultInfo,
            errStr to response.errStr,
            openId to response.openId,
            type to response.type
        )

        fluwxChannel?.invokeMethod("onWXOpenBusinessWebviewResponse", result)
    }

    private fun handlerWXOpenCustomerServiceChatResponse(response: WXOpenCustomerServiceChat.Resp) {
        val result = mapOf(
            errCode to response.errCode,
            errStr to response.errStr,
            openId to response.openId,
            type to response.type
        )

        fluwxChannel?.invokeMethod("onWXOpenCustomerServiceChatResponse", result)
    }

    private fun logToFlutter(tag: String?, message: String?) {
        fluwxChannel?.invokeMethod(
            "wechatLog", mapOf(
                "detail" to "$tag : $message"
            )
        )
    }


}
