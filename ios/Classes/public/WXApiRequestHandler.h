//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "FluwxResponseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXApiRequestHandler : NSObject

+ (void)sendText:(NSString *)text
         InScene:(enum WXScene)scene
      completion:(void (^ __nullable)(BOOL success))completion;

+ (void)sendImageData:(NSData *)imageData
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene
                title:(NSString *)title
          description:(NSString *)description
           completion:(void (^ __nullable)(BOOL success))completion;

+ (void)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
         MessageExt:(NSString *)messageExt
      MessageAction:(NSString *)messageAction
            InScene:(enum WXScene)scene
         completion:(void (^ __nullable)(BOOL success))completion;

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
          completion:(void (^ __nullable)(BOOL success))completion;

+ (void)sendVideoURL:(NSString *)videoURL
     VideoLowBandUrl:(NSString *)videoLowBandUrl
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
          MessageExt:(NSString *)messageExt
       MessageAction:(NSString *)messageAction
             TagName:(NSString *)tagName
             InScene:(enum WXScene)scene
          completion:(void (^ __nullable)(BOOL success))completion;

+ (void)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene
             completion:(void (^ __nullable)(BOOL success))completion;

+ (void)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene
          completion:(void (^ __nullable)(BOOL success))completion;

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
                       completion:(void (^ __nullable)(BOOL success))completion;

+ (void)launchMiniProgramWithUserName:(NSString *)userName
                                 path:(NSString *)path
                                 type:(WXMiniProgramType)miniProgramType
                           completion:(void (^ __nullable)(BOOL success))completion;

+ (void)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage
                   InScene:(enum WXScene)scene
                completion:(void (^ __nullable)(BOOL success))completion;

+ (void)addCardsToCardPackage:(NSArray *)cardIds cardExts:(NSArray *)cardExts
                   completion:(void (^ __nullable)(BOOL success))completion;

+ (void)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController
                  completion:(void (^ __nullable)(BOOL success))completion;

+ (void)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
                  completion:(void (^ __nullable)(BOOL success))completion;



+ (void)chooseCard:(NSString *)appid
          cardSign:(NSString *)cardSign
          nonceStr:(NSString *)nonceStr
          signType:(NSString *)signType
         timestamp:(UInt32)timestamp
        completion:(void (^ __nullable)(BOOL success))completion;

+ (void)openUrl:(NSString *)url
     completion:(void (^ __nullable)(BOOL success))completion;

+ (void)chooseInvoice:(NSString *)appid
             cardSign:(NSString *)cardSign
             nonceStr:(NSString *)nonceStr
             signType:(NSString *)signType
            timestamp:(UInt32)timestamp
           completion:(void (^ __nullable)(BOOL success))completion;


+ (void)sendPayment:(NSString *)appId
          PartnerId:(NSString *)partnerId
           PrepayId:(NSString *)prepayId
           NonceStr:(NSString *)nonceStr
          Timestamp:(UInt32)timestamp
            Package:(NSString *)package
               Sign:(NSString *)sign
         completion:(void (^ __nullable)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
