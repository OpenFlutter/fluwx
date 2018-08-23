#import <Flutter/Flutter.h>
#import "FluwxMethods.h"
#import "FluwxKeys.h"
@class FluwxShareHandler;
@class FluwxResponseHandler;


extern BOOL isWeChatRegistered;


@interface FluwxPlugin : NSObject<FlutterPlugin> {

@private
    FluwxShareHandler *_fluwxShareHandler;
}

@end
