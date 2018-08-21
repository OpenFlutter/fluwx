#import <Flutter/Flutter.h>
#import "FluwxMethods.h"
@class FluwxShareHandler;



extern BOOL isWeChatRegistered;


@interface FluwxPlugin : NSObject<FlutterPlugin> {

@private
    FluwxShareHandler *_fluwxShareHandler;
}

@end
