//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "FluwxResponseHandler.h"
#import "FluwxKeys.h"
#import "StringUtil.h"
#import "WXApiObject.h"
#import "WXApi.h"
@implementation FluwxResponseHandler

const NSString *errStr = @"errStr";
const NSString *errCode = @"errCode";
const NSString *openId = @"openId";
const NSString *type = @"type";
const NSString *lang = @"lang";
const NSString *country = @"country";
const NSString *description = @"description";

#pragma mark - LifeCycle

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static FluwxResponseHandler *instance;
    dispatch_once(&onceToken, ^{
        instance = [[FluwxResponseHandler alloc] init];
    });
    return instance;
}

FlutterMethodChannel *fluwxMethodChannel = nil;

- (void)setMethodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    fluwxMethodChannel = flutterMethodChannel;
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *) resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
//            @{fluwxKeyPlatform: fluwxKeyIOS, fluwxKeyResult: @(done)}
        }


        SendMessageToWXResp *messageResp = (SendMessageToWXResp *) resp;


        NSDictionary *result = @{
                description: messageResp.description == nil ? @"" : messageResp.description,
                errStr: messageResp.errStr == nil ? @"" : messageResp.errStr,
                errCode: @(messageResp.errCode),
                type: messageResp.type == nil ? @2 : @(messageResp.type),
                country: messageResp.country == nil ? @"" : messageResp.country,
                lang: messageResp.lang == nil ? @"" : messageResp.lang,
                fluwxKeyPlatform: fluwxKeyIOS
        };
        [fluwxMethodChannel invokeMethod:@"onShareResponse" arguments:result];


    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *) resp;
            [_delegate managerDidRecvAuthResponse:authResp];

        }


        SendAuthResp *authResp = (SendAuthResp *) resp;
        NSDictionary *result = @{
                description: authResp.description == nil ? @"" : authResp.description,
                errStr: authResp.errStr == nil ? @"" : authResp.errStr,
                errCode: @(authResp.errCode),
                type: authResp.type == nil ? @1 : @(authResp.type),
                country: authResp.country == nil ? @"" : authResp.country,
                lang: authResp.lang == nil ? @"" : authResp.lang,
                fluwxKeyPlatform: fluwxKeyIOS,
                @"code": [StringUtil nilToEmpty:authResp.code],
                @"state": [StringUtil nilToEmpty:authResp.state]

        };
        [fluwxMethodChannel invokeMethod:@"onAuthResponse" arguments:result];

    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *) resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    } else if ([resp isKindOfClass:[WXChooseCardResp class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvChooseCardResponse:)]) {
            WXChooseCardResp *chooseCardResp = (WXChooseCardResp *) resp;
            [_delegate managerDidRecvChooseCardResponse:chooseCardResp];
        }
    } else if ([resp isKindOfClass:[WXChooseInvoiceResp class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvChooseInvoiceResponse:)]) {
            WXChooseInvoiceResp *chooseInvoiceResp = (WXChooseInvoiceResp *) resp;
            [_delegate managerDidRecvChooseInvoiceResponse:chooseInvoiceResp];
        }
    } else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]) {
        if ([_delegate respondsToSelector:@selector(managerDidRecvSubscribeMsgResponse:)]) {
            [_delegate managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *) resp];
        }

        WXSubscribeMsgResp *subscribeMsgResp = (WXSubscribeMsgResp *) resp;
        NSDictionary *subMsgResult = @{
                @"openid": subscribeMsgResp.openId,
                @"templateId": subscribeMsgResp.templateId,
                @"action": subscribeMsgResp.action,
                @"reserved": subscribeMsgResp.reserved,
                @"scene": @(subscribeMsgResp.scene),
        };

        [fluwxMethodChannel invokeMethod:@"onSubscribeMsgResp" arguments:subMsgResult];
    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        if ([_delegate respondsToSelector:@selector(managerDidRecvLaunchMiniProgram:)]) {
            [_delegate managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *) resp];
        }


        WXLaunchMiniProgramResp *miniProgramResp = (WXLaunchMiniProgramResp *) resp;


        NSDictionary *commonResult = @{
                description: miniProgramResp.description == nil ? @"" : miniProgramResp.description,
                errStr: miniProgramResp.errStr == nil ? @"" : miniProgramResp.errStr,
                errCode: @(miniProgramResp.errCode),
                type: miniProgramResp.type == nil ? @1 : @(miniProgramResp.type),
                fluwxKeyPlatform: fluwxKeyIOS,

        };

        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:commonResult];
        if (miniProgramResp.extMsg != nil) {
            result[@"extMsg"] = miniProgramResp.extMsg;
        }


//        @"extMsg":miniProgramResp.extMsg == nil?@"":miniProgramResp.extMsg


        [fluwxMethodChannel invokeMethod:@"onLaunchMiniProgramResponse" arguments:result];

    } else if ([resp isKindOfClass:[WXInvoiceAuthInsertResp class]]) {
        if ([_delegate respondsToSelector:@selector(managerDidRecvInvoiceAuthInsertResponse:)]) {
            [_delegate managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *) resp];
        }
    } else if ([resp isKindOfClass:[WXNontaxPayResp class]]) {
        if ([_delegate respondsToSelector:@selector(managerDidRecvNonTaxpayResponse:)]) {
            [_delegate managerDidRecvNonTaxpayResponse:(WXNontaxPayResp *) resp];
        }
    } else if ([resp isKindOfClass:[WXPayInsuranceResp class]]) {
        if ([_delegate respondsToSelector:@selector(managerDidRecvPayInsuranceResponse:)]) {
            [_delegate managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *) resp];
        }
    } else if ([resp isKindOfClass:[PayResp class]]) {
        if ([_delegate respondsToSelector:@selector(managerDidRecvPaymentResponse)]) {
            [_delegate managerDidRecvPaymentResponse:(PayResp *) resp];
        }


        PayResp *payResp = (PayResp *) resp;

        NSDictionary *result = @{
                description: [StringUtil nilToEmpty:payResp.description],
                errStr: [StringUtil nilToEmpty:resp.errStr],
                errCode: @(payResp.errCode),
                type: payResp.type == nil ? @5 : @(payResp.type),
                @"returnKey": payResp.returnKey == nil ? @"" : payResp.returnKey,
                fluwxKeyPlatform: fluwxKeyIOS,
        };
        [fluwxMethodChannel invokeMethod:@"onPayResponse" arguments:result];
    } else if ([resp isKindOfClass:[WXOpenBusinessWebViewResp class]]) {
        WXOpenBusinessWebViewResp *businessResp = (WXOpenBusinessWebViewResp *) resp;

        NSDictionary *result = @{
                description: [StringUtil nilToEmpty:businessResp.description],
                errStr: [StringUtil nilToEmpty:resp.errStr],
                errCode: @(businessResp.errCode),
                type: businessResp.type == nil ? @5 : @(businessResp.type),
                @"resultInfo": businessResp.result,
                @"businessType": @(businessResp.businessType),
                fluwxKeyPlatform: fluwxKeyIOS,
        };

        [fluwxMethodChannel invokeMethod:@"onAutoDeductResponse" arguments:result];
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *) req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *) req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *) req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
