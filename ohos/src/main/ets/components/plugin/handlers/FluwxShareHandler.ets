import { Any, MethodCall, MethodResult } from "@ohos/flutter_ohos"
import * as wechatSDK from "@tencent/wechat_open_sdk"
import { WXAPiHandler } from "./WXAPiHandler"
import { buffer } from "@kit.ArkTS"
import { fileUri } from "@kit.CoreFileKit"

export class FluwxShareHandler {
  share(call: MethodCall, result: MethodResult) {
    if (!WXAPiHandler.wxApi) {
      result.error("Unassigned WxApi", "please config  wxapi first", null);
      return;
    }

    switch (call.method) {
      case "shareText":
        this.shareText(call, result);
        break;
      case "shareMiniProgram":
        // TODO
        result.notImplemented();
        break;
      case "shareImage":
        this.shareImage(call, result);
        break;
      case "shareMusic":
        // TODO
        result.notImplemented();
        break;
      case "shareVideo":
        // TODO
        result.notImplemented();
        break;
      case "shareWebPage":
        // TODO
        result.notImplemented();
        break;
      case "shareFile":
        // TODO
        result.notImplemented();
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  async shareText(call: MethodCall, result: MethodResult) {
    const textObj = new wechatSDK.WXTextObject();
    textObj.text = call.argument("source");

    const mediaMsg = new wechatSDK.WXMediaMessage();
    mediaMsg.mediaObject = textObj;

    const req = new wechatSDK.SendMessageToWXReq();
    req.message = mediaMsg;

    const done = await WXAPiHandler.wxApi?.sendReq(WXAPiHandler.uiContext, req);

    result.success(done)
  }

  async shareImage(call: MethodCall, result: MethodResult) {
    const map: Map<string, Any> = call.argument("source") ?? new Map();
    // const imageHash: string | null = call.argument("imgDataHash");
    const bytes: Uint8Array | null = map.get("uint8List");

    const imageObj = new wechatSDK.WXImageObject();

    if (bytes) {
      const buff: buffer.Buffer = buffer.from(bytes.buffer);
      imageObj.imageData = buff.toString("base64", 0, buff.length);
    } else {
      const localImagePath: string | null = map.get("localImagePath");
      if (localImagePath) {
        imageObj.uri = localImagePath.startsWith("file://") ? localImagePath : fileUri.getUriFromPath(localImagePath)
      }
    }

    const mediaMsg = new wechatSDK.WXMediaMessage();
    mediaMsg.mediaObject = imageObj;

    const req = new wechatSDK.SendMessageToWXReq();
    req.message = mediaMsg;

    const done = await WXAPiHandler.wxApi?.sendReq(WXAPiHandler.uiContext, req);
    result.success(done);
  }
}