import Flutter
import UIKit
import wechat_plugin

public class SwiftWechatPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wechat_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftWechatPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        switch call.method {
        case WeChatPluginMethods.SHARE_TEXT:
            print("hh")
            break;

        default:
            print("hh")
        }
    }
}
