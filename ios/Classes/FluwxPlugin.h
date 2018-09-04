#import <Flutter/Flutter.h>
#import "FluwxMethods.h"
#import "FluwxKeys.h"
#import "FluwxWXApiHandler.h"
#import "FluwxShareHandler.h"


@class FluwxShareHandler;
@class FluwxResponseHandler;
@class FluwxAuthHandler;
@class FluwxWXApiHandler;
@class FluwxPaymentHandler;

extern BOOL isWeChatRegistered;


@interface FluwxPlugin : NSObject<FlutterPlugin> {

@private
    FluwxShareHandler *_fluwxShareHandler;
@private
    FluwxAuthHandler *_fluwxAuthHandler;
@private FluwxWXApiHandler *_fluwxWXApiHandler;
@private FluwxPaymentHandler *_fluwxPaymentHandler;

}

@end
