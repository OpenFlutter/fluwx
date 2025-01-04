import { Any, MethodCall, MethodResult } from "@ohos/flutter_ohos"
import { buffer } from "@kit.ArkTS"
import { fileUri } from "@kit.CoreFileKit"
import * as wxopensdk from '@tencent/wechat_open_sdk';
import { WXAPiHandler } from "./WXAPiHandler"

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
        this.shareMiniProgram(call, result);
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
        this.shareWebPage(call, result);
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
    const textObj = new wxopensdk.WXTextObject();
    textObj.text = call.argument("source");

    const mediaMsg = new wxopensdk.WXMediaMessage();
    mediaMsg.mediaObject = textObj;

    const req = new wxopensdk.SendMessageToWXReq();
    req.message = mediaMsg;

    const done = await WXAPiHandler.wxApi?.sendReq(WXAPiHandler.uiContext, req);

    result.success(done)
  }

  async shareImage(call: MethodCall, result: MethodResult) {
    const map: Map<string, Any> = call.argument("source") ?? new Map();
    // const imageHash: string | null = call.argument("imgDataHash");
    const bytes: Uint8Array | null = map.get("uint8List");

    const imageObj = new wxopensdk.WXImageObject();

    if (bytes) {
      const buff: buffer.Buffer = buffer.from(bytes.buffer);
      imageObj.imageData = buff.toString("base64", 0, buff.length);
    } else {
      const localImagePath: string | null = map.get("localImagePath");
      if (localImagePath) {
        imageObj.uri = localImagePath.startsWith("file://") ? localImagePath : fileUri.getUriFromPath(localImagePath)
      }
    }

    const mediaMsg = new wxopensdk.WXMediaMessage();
    mediaMsg.mediaObject = imageObj;

    const req = new wxopensdk.SendMessageToWXReq();
    req.message = mediaMsg;

    const done = await WXAPiHandler.wxApi?.sendReq(WXAPiHandler.uiContext, req);
    result.success(done);
  }

  async shareWebPage(call: MethodCall, result: MethodResult) {
    const webpageObject = new wxopensdk.WXWebpageObject()
    webpageObject.webpageUrl = call.argument("webPage")

    const mediaMessage = new wxopensdk.WXMediaMessage()
    mediaMessage.mediaObject = webpageObject
    mediaMessage.title = call.argument("title")
    mediaMessage.description = call.argument("description")

    const thumbData: Uint8Array | null = call.argument("thumbData");
    if (thumbData) {
      mediaMessage.thumbData = thumbData;
    }

    const req = new wxopensdk.SendMessageToWXReq()
    req.scene = wxopensdk.SendMessageToWXReq.WXSceneSession
    req.message = mediaMessage

    const done = await WXAPiHandler.wxApi?.sendReq(WXAPiHandler.uiContext, req);

    result.success(done)
  }

  async shareMiniProgram(call: MethodCall, result: MethodResult) {
    const miniProgramObject = new wxopensdk.WXMiniProgramObject()
    miniProgramObject.userName = call.argument("userName")
    miniProgramObject.path = call.argument("path")
    miniProgramObject.miniprogramType = wxopensdk.WXMiniProgramType.RELEASE

    const mediaMessage = new wxopensdk.WXMediaMessage()
    mediaMessage.mediaObject = miniProgramObject
    mediaMessage.title = call.argument("title")
    mediaMessage.description = call.argument("description")

    const thumbData: Uint8Array | null = call.argument("thumbData");
    if (thumbData) {
      mediaMessage.thumbData = thumbData;
    }

    const req = new wxopensdk.SendMessageToWXReq()
    req.scene = wxopensdk.SendMessageToWXReq.WXSceneSession
    req.message = mediaMessage

    const done = await WXAPiHandler.wxApi?.sendReq(WXAPiHandler.uiContext, req);

    result.success(done)
  }
}