//
//  MPMathJaxCallbackHandler.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 07/8.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface MPMathJaxListener : NSObject <WKScriptMessageHandler>

- (void)addCallback:(void (^)(void))block forKey:(NSString *)key;
- (void)invokeCallbackForKey:(NSString *)key;

@end
