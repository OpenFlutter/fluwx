#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@import fluwx;

// This demonstrates a simple unit test of the Objective-C portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

@interface RunnerTests : XCTestCase

@end

@implementation RunnerTests

- (void)testExample {
  FluwxPlugin *plugin = [[FluwxPlugin alloc] init];

  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"getPlatformVersion"
                                                              arguments:nil];
  XCTestExpectation *expectation = [self expectationWithDescription:@"result block must be called"];
  [plugin handleMethodCall:call
                    result:^(id result) {
                      NSString *expected = [NSString
                          stringWithFormat:@"iOS %@", UIDevice.currentDevice.systemVersion];
                      XCTAssertEqualObjects(result, expected);
                      [expectation fulfill];
                    }];
  [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end
