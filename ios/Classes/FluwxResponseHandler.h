//
// Created by mo on 2020/3/7.
//

#import <Foundation/Foundation.h>

#import <Flutter/Flutter.h>

#import <Flutter/Flutter.h>
#import <WXApi.h>
#import "WXApiObject.h"

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

- (void)managerDidRecvChooseCardResponse:(WXChooseCardResp *)response;

- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response;

- (void)managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)response;

- (void)managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)response;

- (void)managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *)response;
@end

@interface FluwxResponseHandler : NSObject <WXApiDelegate>

@property(nonatomic, assign) id <WXApiManagerDelegate> delegate;

+ (instancetype)defaultManager;

- (void)setMethodChannel:(FlutterMethodChannel *)flutterMethodChannel;

@end
