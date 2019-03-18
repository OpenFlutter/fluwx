#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include <fluwx/FluwxResponseHandler.h>
#include <fluwx/WXApi.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//  return  [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
//}
//
//
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{

  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}



- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
