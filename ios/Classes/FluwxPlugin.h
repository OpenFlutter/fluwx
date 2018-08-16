#import <Flutter/Flutter.h>
@class FluwxShareHandler;



extern BOOL isWeChatRegistered;


@interface FluwxPlugin : NSObject<FlutterPlugin> {

@private
    FluwxShareHandler *_fluwxShareHandler;
}

@end
