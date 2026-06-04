//
//  MPMathJaxListenerTests.m
//  MacDownTests
//
//  Created for the WKWebView migration.
//

#import <XCTest/XCTest.h>
#import <WebKit/WebKit.h>
#import "MPMathJaxListener.h"


@interface MPFakeScriptMessage : NSObject
@property (nonatomic) id body;
@end

@implementation MPFakeScriptMessage
@end


@interface MPMathJaxListenerTests : XCTestCase
@end


@implementation MPMathJaxListenerTests

- (void)testWKScriptMessageInvokesRegisteredCallback
{
    MPMathJaxListener *listener = [[MPMathJaxListener alloc] init];
    __block BOOL invoked = NO;
    [listener addCallback:^{
        invoked = YES;
    } forKey:@"End"];

    MPFakeScriptMessage *message = [[MPFakeScriptMessage alloc] init];
    message.body = @"End";

    SEL selector = @selector(userContentController:didReceiveScriptMessage:);
    XCTAssertTrue([listener respondsToSelector:selector]);
    [(id)listener userContentController:[[WKUserContentController alloc] init]
                didReceiveScriptMessage:(WKScriptMessage *)message];

    XCTAssertTrue(invoked);
}

@end
