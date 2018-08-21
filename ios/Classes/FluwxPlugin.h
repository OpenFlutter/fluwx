#import <Flutter/Flutter.h>
#import "FluwxMethods.h"
#import "FluwxKeys.h"
@class FluwxShareHandler;



extern BOOL isWeChatRegistered;


@interface FluwxPlugin : NSObject<FlutterPlugin> {

@private
    FluwxShareHandler *_fluwxShareHandler;
}

@end
