//
// Created by mo on 2020/3/7.
//

#import <WechatOpenSDK/WXApi.h>
#import "WXApiRequestHandler.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
#import "WXMediaMessage+messageConstruct.h"
#import "FluwxStringUtil.h"
#import <WechatOpenSDK/WXApiObject.h>

@implementation WXApiRequestHandler

#pragma mark - Public Methods

+ (void)sendText:(NSString *)text
         InScene:(enum WXScene)scene
      completion:(void (^ __nullable)(BOOL success))completion {
    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:text
                                                   OrMediaMessage:nil
                                                            bText:YES
                                                          InScene:scene];

    [WXApi sendReq:req completion:completion];
}

+ (void)sendImageData:(NSData *)imageData
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene
                title:(NSString *)title
          description:(NSString *)description
           completion:(void (^ __nullable)(BOOL success))completion {
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;


    WXMediaMessage *message = [WXMediaMessage messageWithTitle:(title == (id) [NSNull null]) ? nil : title
                                                   Description:(description == (id) [NSNull null]) ? nil : description
                                                        Object:ext
                                                    MessageExt:(messageExt == (id) [NSNull null]) ? nil : messageExt
                                                 MessageAction:(action == (id) [NSNull null]) ? nil : action
                                                    ThumbImage:thumbImage
                                                      MediaTag:(tagName == (id) [NSNull null]) ? nil : tagName];

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];

    [WXApi sendReq:req completion:completion];
}

+ (void)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
         MessageExt:(NSString *)messageExt
      MessageAction:(NSString *)messageAction
            InScene:(enum WXScene)scene
         completion:(void (^ __nullable)(BOOL success))completion {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;

    WXMediaMessage *message = [WXMediaMessage messageWithTitle:(title == (id) [NSNull null]) ? nil : title
                                                   Description:(description == (id) [NSNull null]) ? nil : description
                                                        Object:ext
                                                    MessageExt:(messageExt == (id) [NSNull null]) ? nil : messageExt
                                                 MessageAction:(messageAction == (id) [NSNull null]) ? nil : messageAction
                                                    ThumbImage:thumbImage
                                                      MediaTag:(tagName == (id) [NSNull null]) ? nil : tagName];

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    [WXApi sendReq:req completion:completion];
}

+ (void)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
     MusicLowBandUrl:(NSString *)musicLowBandUrl
 MusicLowBandDataUrl:(NSString *)musicLowBandDataUrl
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
          MessageExt:(NSString *)messageExt
       MessageAction:(NSString *)messageAction
             TagName:(NSString *)tagName
             InScene:(enum WXScene)scene
          completion:(void (^ __nullable)(BOOL success))completion {
    WXMusicObject *ext = [WXMusicObject object];

    if ([FluwxStringUtil isBlank:musicURL]) {
        ext.musicLowBandUrl = musicLowBandUrl;
        ext.musicLowBandDataUrl = (musicLowBandDataUrl == (id) [NSNull null]) ? nil : musicLowBandDataUrl;
    } else {
        ext.musicUrl = musicURL;
        ext.musicDataUrl = (dataURL == (id) [NSNull null]) ? nil : dataURL;
    }


    WXMediaMessage *message = [WXMediaMessage messageWithTitle:(title == (id) [NSNull null]) ? nil : title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:(messageExt == (id) [NSNull null]) ? nil : messageExt
                                                 MessageAction:(messageAction == (id) [NSNull null]) ? nil : messageAction
                                                    ThumbImage:thumbImage
                                                      MediaTag:(tagName == (id) [NSNull null]) ? nil : tagName];

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];

    [WXApi sendReq:req completion:completion];
}

+ (void)sendVideoURL:(NSString *)videoURL
     VideoLowBandUrl:(NSString *)videoLowBandUrl
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
          MessageExt:(NSString *)messageExt
       MessageAction:(NSString *)messageAction
             TagName:(NSString *)tagName
             InScene:(enum WXScene)scene
          completion:(void (^ __nullable)(BOOL success))completion {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = (title == (id) [NSNull null]) ? nil : title;
    message.description = (description == (id) [NSNull null]) ? nil : description;
    message.messageExt = (messageExt == (id) [NSNull null]) ? nil : messageExt;
    message.messageAction = (messageAction == (id) [NSNull null]) ? nil : messageAction;
    message.mediaTagName = (tagName == (id) [NSNull null]) ? nil : tagName;
    [message setThumbImage:thumbImage];

    WXVideoObject *ext = [WXVideoObject object];
    if ([FluwxStringUtil isBlank:videoURL]) {
        ext.videoLowBandUrl = videoLowBandUrl;
    } else {
        ext.videoUrl = videoURL;
    }
    message.mediaObject = ext;

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    [WXApi sendReq:req completion:completion];
}

+ (void)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene
             completion:(void (^ __nullable)(BOOL success))completion {
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];

    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = emotionData;

    message.mediaObject = ext;

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    [WXApi sendReq:req completion:completion];
}

+ (void)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene
          completion:(void (^ __nullable)(BOOL success))completion {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];

    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = extension;
    ext.fileData = fileData;

    message.mediaObject = ext;

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    [WXApi sendReq:req completion:completion];
}

+ (void)sendMiniProgramWebpageUrl:(NSString *)webpageUrl
                         userName:(NSString *)userName
                             path:(NSString *)path
                            title:(NSString *)title
                      Description:(NSString *)description
                       ThumbImage:(UIImage *)thumbImage
                      hdImageData:(NSData *)hdImageData
                  withShareTicket:(BOOL)withShareTicket
                  miniProgramType:(WXMiniProgramType)programType
                       MessageExt:(NSString *)messageExt
                    MessageAction:(NSString *)messageAction
                          TagName:(NSString *)tagName
                          InScene:(enum WXScene)scene
                       completion:(void (^ __nullable)(BOOL success))completion {
    WXMiniProgramObject *ext = [WXMiniProgramObject object];
    ext.webpageUrl = (webpageUrl == (id) [NSNull null]) ? nil : webpageUrl;
    ext.userName = (userName == (id) [NSNull null]) ? nil : userName;
    ext.path = (path == (id) [NSNull null]) ? nil : path;
    ext.hdImageData = (hdImageData == (id) [NSNull null]) ? nil : hdImageData;
    ext.withShareTicket = withShareTicket;


//    WXMiniProgramType miniProgramType = WXMiniProgramTypeRelease;
//    if(programType == 0){
//        miniProgramType = WXMiniProgramTypeRelease;
//    } else if(programType == 1){
//        miniProgramType =WXMiniProgramTypeTest;
//    } else if(programType == 2){
//        miniProgramType = WXMiniProgramTypePreview;
//    }

    ext.miniProgramType = programType;

    WXMediaMessage *message = [WXMediaMessage messageWithTitle:(title == (id) [NSNull null]) ? nil : title
                                                   Description:(description == (id) [NSNull null]) ? nil : description
                                                        Object:ext
                                                    MessageExt:(messageExt == (id) [NSNull null]) ? nil : messageExt
                                                 MessageAction:(messageAction == (id) [NSNull null]) ? nil : messageAction
                                                    ThumbImage:thumbImage
                                                      MediaTag:(tagName == (id) [NSNull null]) ? nil : tagName];

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];

    [WXApi sendReq:req completion:completion];
}

+ (void)launchMiniProgramWithUserName:(NSString *)userName
                                 path:(NSString *)path
                                 type:(WXMiniProgramType)miniProgramType
                           completion:(void (^ __nullable)(BOOL success))completion {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = userName;
    launchMiniProgramReq.path = (path == (id) [NSNull null]) ? nil : path;
    launchMiniProgramReq.miniProgramType = miniProgramType;

    [WXApi sendReq:launchMiniProgramReq completion:completion];
}


+ (void)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage
                   InScene:(enum WXScene)scene
                completion:(void (^ __nullable)(BOOL success))completion {
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = info;
    ext.url = url;
    ext.fileData = data;

    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:action
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    [WXApi sendReq:req completion:completion];

}

+ (void)addCardsToCardPackage:(NSArray *)cardIds cardExts:(NSArray *)cardExts
                   completion:(void (^ __nullable)(BOOL success))completion {
    NSMutableArray *cardItems = [NSMutableArray array];
    for (NSString *cardId in cardIds) {
        WXCardItem *item = [[WXCardItem alloc] init];
        item.cardId = cardId;
        item.appID = @"wxf8b4f85f3a794e77";
        [cardItems addObject:item];
    }

    for (NSInteger index = 0; index < cardItems.count; index++) {
        WXCardItem *item = cardItems[index];
        NSString *ext = cardExts[index];
        item.extMsg = ext;
    }

    AddCardToWXCardPackageReq *req = [[AddCardToWXCardPackageReq alloc] init];
    req.cardAry = cardItems;
    [WXApi sendReq:req completion:completion];
}

+ (void)chooseCard:(NSString *)appid
          cardSign:(NSString *)cardSign
          nonceStr:(NSString *)nonceStr
          signType:(NSString *)signType
         timestamp:(UInt32)timestamp
        completion:(void (^ __nullable)(BOOL success))completion {
    WXChooseCardReq *chooseCardReq = [[WXChooseCardReq alloc] init];
    chooseCardReq.appID = appid;
    chooseCardReq.cardSign = cardSign;
    chooseCardReq.nonceStr = nonceStr;
    chooseCardReq.signType = signType;
    chooseCardReq.timeStamp = timestamp;
    [WXApi sendReq:chooseCardReq completion:completion];

}

+ (void)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController
                  completion:(void (^ __nullable)(BOOL success))completion {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;


    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:[FluwxResponseHandler defaultManager]
                   completion:completion];
}

+ (void)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
                  completion:(void (^ __nullable)(BOOL success))completion {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;

    [WXApi sendReq:req completion:completion];
}





+ (void)openUrl:(NSString *)url
     completion:(void (^ __nullable)(BOOL success))completion {
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = url;
    [WXApi sendReq:req completion:completion];
}

+ (void)chooseInvoice:(NSString *)appid
             cardSign:(NSString *)cardSign
             nonceStr:(NSString *)nonceStr
             signType:(NSString *)signType
            timestamp:(UInt32)timestamp
           completion:(void (^ __nullable)(BOOL success))completion {
    WXChooseInvoiceReq *chooseInvoiceReq = [[WXChooseInvoiceReq alloc] init];
    chooseInvoiceReq.appID = appid;
    chooseInvoiceReq.cardSign = cardSign;
    chooseInvoiceReq.nonceStr = nonceStr;
    chooseInvoiceReq.signType = signType;
//    chooseCardReq.cardType = @"INVOICE";
    chooseInvoiceReq.timeStamp = timestamp;
//    chooseCardReq.canMultiSelect = 1;
    [WXApi sendReq:chooseInvoiceReq completion:completion];
}


+ (void)sendPayment:(NSString *)appId PartnerId:(NSString *)partnerId PrepayId:(NSString *)prepayId NonceStr:(NSString *)nonceStr Timestamp:(UInt32)timestamp Package:(NSString *)package Sign:(NSString *)sign
         completion:(void (^ __nullable)(BOOL success))completion {

    PayReq *req = [[PayReq alloc] init];
    req.openID = (appId == (id) [NSNull null]) ? nil : appId;
    req.partnerId = partnerId;
    req.prepayId = prepayId;
    req.nonceStr = nonceStr;
    req.timeStamp = timestamp;
    req.package = package;
    req.sign = sign;


    [WXApi sendReq:req completion:completion];
}

@end
