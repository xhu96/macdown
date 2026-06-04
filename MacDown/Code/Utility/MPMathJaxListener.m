//
//  MPMathJaxCallbackHandler.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 07/8.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "MPMathJaxListener.h"

@interface MPMathJaxListener ()
@property (nonatomic) NSMutableDictionary *callbacks;
@end

@implementation MPMathJaxListener

- (NSMutableDictionary *)callbacks
{
    if (!_callbacks)
        _callbacks = [[NSMutableDictionary alloc] init];
    return _callbacks;
}

- (void)addCallback:(void (^)(void))block forKey:(NSString *)key
{
    self.callbacks[key] = block;
}

- (void)invokeCallbackForKey:(NSString *)key
{
    id object = self.callbacks[key];
    if (object)
    {
        void (^block)(void) = object;
        block();
    }
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (![message.body isKindOfClass:NSString.class])
        return;
    [self invokeCallbackForKey:message.body];
}

@end
