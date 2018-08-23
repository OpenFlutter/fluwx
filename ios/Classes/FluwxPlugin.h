#import <Flutter/Flutter.h>
#import "FluwxMethods.h"
#import "FluwxKeys.h"
@class FluwxShareHandler;
@class FluwxResponseHandler;
@class FluwxAuthHandler;

extern BOOL isWeChatRegistered;


@interface FluwxPlugin : NSObject<FlutterPlugin> {

@private
    FluwxShareHandler *_fluwxShareHandler;
@private
    FluwxAuthHandler *_fluwxAuthHandler;
}

@end
