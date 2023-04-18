//
// Created by mo on 2020/3/7.
//

#import <Flutter/Flutter.h>
#import "FluwxStringUtil.h"
#import <WXApiObject.h>
#import "FluwxResponseHandler.h"
#import "FluwxDelegate.h"

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

- (void)onNeedGrantReadPasteBoardPermissionWithURL:(nonnull NSURL *)openURL completion:(nonnull WXGrantReadPasteBoardPermissionCompletion)completion {
    /// allow wechat OpenSDK to accessing the clipboard and paste
    dispatch_async(dispatch_get_main_queue(), ^{
        completion();
    });
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *) resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }

        SendMessageToWXResp *messageResp = (SendMessageToWXResp *) resp;


        NSDictionary *result = @{
                description: messageResp.description == nil ? @"" : messageResp.description,
                errStr: messageResp.errStr == nil ? @"" : messageResp.errStr,
                errCode: @(messageResp.errCode),
                type: @(messageResp.type),
                country: messageResp.country == nil ? @"" : messageResp.country,
                lang: messageResp.lang == nil ? @"" : messageResp.lang};
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
                type: @(authResp.type),
                country: authResp.country == nil ? @"" : authResp.country,
                lang: authResp.lang == nil ? @"" : authResp.lang,
                @"code": [FluwxStringUtil nilToEmpty:authResp.code],
                @"state": [FluwxStringUtil nilToEmpty:authResp.state]

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
        //TODO 处理发票返回，并回调Dart
        
        WXChooseInvoiceResp *chooseInvoiceResp = (WXChooseInvoiceResp *) resp;
    
        
        NSArray *array =  chooseInvoiceResp.cardAry;
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];

        
        for (int i = 0; i< array.count; i++) {
            WXInvoiceItem *item =  array[i];
            
            
            NSDictionary *dict = @{@"app_id":item.appID, @"encrypt_code":item.encryptCode, @"card_id":item.cardId};
            [mutableArray addObject:dict];
        }
        
        NSError *error = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableArray options:NSJSONWritingPrettyPrinted error: &error];
        
        NSString *cardItemList = @"";
        
        if ([jsonData length] && error == nil) {
            cardItemList = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }

            NSDictionary *result = @{
                    description: chooseInvoiceResp.description == nil ? @"" : chooseInvoiceResp.description,
                    errStr: chooseInvoiceResp.errStr == nil ? @"" : chooseInvoiceResp.errStr,
                    errCode: @(chooseInvoiceResp.errCode),
                    type: @(chooseInvoiceResp.type),
                    @"cardItemList":cardItemList
            };

            [fluwxMethodChannel invokeMethod:@"onOpenWechatInvoiceResponse" arguments:result];
        
    } else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]) {
        if ([_delegate respondsToSelector:@selector(managerDidRecvSubscribeMsgResponse:)]) {
            [_delegate managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *) resp];
        }

        WXSubscribeMsgResp *subscribeMsgResp = (WXSubscribeMsgResp *) resp;
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSString *openid = subscribeMsgResp.openId;
        if(openid != nil && openid != NULL && ![openid isKindOfClass:[NSNull class]]){
           result[@"openid"] = openid;
        }
        
        NSString *templateId = subscribeMsgResp.templateId;
        if(templateId != nil && templateId != NULL && ![templateId isKindOfClass:[NSNull class]]){
           result[@"templateId"] = templateId;
        }
        
        NSString *action = subscribeMsgResp.action;
        if(action != nil && action != NULL && ![action isKindOfClass:[NSNull class]]){
            result[@"action"] = action;
        }
        
        NSString *reserved = subscribeMsgResp.action;
        if(reserved != nil && reserved != NULL && ![reserved isKindOfClass:[NSNull class]]){
          result[@"reserved"] = reserved;
        }
        
        UInt32 scene = subscribeMsgResp.scene;
        result[@"scene"] = @(scene);

        [fluwxMethodChannel invokeMethod:@"onSubscribeMsgResp" arguments:result];
    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        if ([_delegate respondsToSelector:@selector(managerDidRecvLaunchMiniProgram:)]) {
            [_delegate managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *) resp];
        }


        WXLaunchMiniProgramResp *miniProgramResp = (WXLaunchMiniProgramResp *) resp;


        NSDictionary *commonResult = @{
                description: miniProgramResp.description == nil ? @"" : miniProgramResp.description,
                errStr: miniProgramResp.errStr == nil ? @"" : miniProgramResp.errStr,
                errCode: @(miniProgramResp.errCode),
                type: @(miniProgramResp.type),
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
        if ([_delegate respondsToSelector:@selector(managerDidRecvPaymentResponse:)]) {
            [_delegate managerDidRecvPaymentResponse:(PayResp *) resp];
        }


        PayResp *payResp = (PayResp *) resp;

        NSDictionary *result = @{
                description: [FluwxStringUtil nilToEmpty:payResp.description],
                errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
                errCode: @(payResp.errCode),
                type: @(payResp.type),
                @"extData": [FluwxStringUtil nilToEmpty:[FluwxDelegate defaultManager].extData],
                @"returnKey": [FluwxStringUtil nilToEmpty:payResp.returnKey],
        };
        [FluwxDelegate defaultManager].extData = nil;
        [fluwxMethodChannel invokeMethod:@"onPayResponse" arguments:result];
    } else if ([resp isKindOfClass:[WXOpenBusinessWebViewResp class]]) {
        WXOpenBusinessWebViewResp *businessResp = (WXOpenBusinessWebViewResp *) resp;

        NSDictionary *result = @{
                description: [FluwxStringUtil nilToEmpty:businessResp.description],
                errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
                errCode: @(businessResp.errCode),
                type: @(businessResp.type),
                @"resultInfo": [FluwxStringUtil nilToEmpty:businessResp.result],
                @"businessType": @(businessResp.businessType),
        };

        [fluwxMethodChannel invokeMethod:@"onWXOpenBusinessWebviewResponse" arguments:result];
    } else if ([resp isKindOfClass:[WXOpenCustomerServiceResp class]])
    {
        
        WXOpenCustomerServiceResp *customerResp = (WXOpenCustomerServiceResp *) resp;
        NSDictionary *result = @{
                description: [FluwxStringUtil nilToEmpty:customerResp.description],
                errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
                errCode: @(customerResp.errCode),
                type: @(customerResp.type),
                @"extMsg":[FluwxStringUtil nilToEmpty:customerResp.extMsg]
        };

        [fluwxMethodChannel invokeMethod:@"onWXOpenBusinessWebviewResponse" arguments:result];
     // 相关错误信息
    }else if ([resp isKindOfClass:[WXOpenBusinessViewResp class]])
    {
        
        WXOpenBusinessViewResp *openBusinessViewResp = (WXOpenBusinessViewResp *) resp;
        NSDictionary *result = @{
                description: [FluwxStringUtil nilToEmpty:openBusinessViewResp.description],
                errStr: [FluwxStringUtil nilToEmpty:resp.errStr],
                errCode: @(openBusinessViewResp.errCode),
                @"businessType":openBusinessViewResp.businessType,
                type: @(openBusinessViewResp.type),
                @"extMsg":[FluwxStringUtil nilToEmpty:openBusinessViewResp.extMsg]
        };

        [fluwxMethodChannel invokeMethod:@"onOpenBusinessViewResponse" arguments:result];
     // 相关错误信息
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
        LaunchFromWXReq *launchFromWXReq = (LaunchFromWXReq *) req;
        WXMediaMessage *wmm = launchFromWXReq.message;
        NSString *msg = @"";
        if (wmm == nil || wmm == NULL || [wmm isKindOfClass:[NSNull class]]) {
            msg = @"";
        }else {
            msg = wmm.messageExt;
            if (msg == nil || msg == NULL || [msg isKindOfClass:[NSNull class]]) {
                msg = @"";
            }
        }

        NSDictionary *result = @{
                @"extMsg": msg
        };

        [fluwxMethodChannel invokeMethod:@"onWXShowMessageFromWX" arguments:result];
    }
    
}
@end
