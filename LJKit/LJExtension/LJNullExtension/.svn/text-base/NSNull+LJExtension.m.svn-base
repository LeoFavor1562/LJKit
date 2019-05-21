//
//  NSNull+LJExtension.m
//  SuDianPlay
//
//  Created by coder on 2019/4/1.
//  Copyright © 2019年 coder. All rights reserved.
//

#import "NSNull+LJExtension.h"
#import <objc/runtime.h>

#ifndef NULLSAFE_ENABLED
#define NULLSAFE_ENABLED 1
#endif


#pragma clang diagnostic ignored "-Wgnu-conditional-omitted-operand"

@implementation NSNull (LJExtension)

#if NULLSAFE_ENABLED

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        for (Class someClass in @[
                                  [NSMutableArray class],
                                  [NSMutableDictionary class],
                                  [NSMutableString class],
                                  [NSNumber class],
                                  [NSDate class],
                                  [NSData class]
                                  ]) {
            @try {
                if ([someClass instancesRespondToSelector:selector]) {
                    signature = [someClass instanceMethodSignatureForSelector:selector];
                    break;
                }
            }
            @catch (__unused NSException *unused) {}
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    invocation.target = nil;
    [invocation invoke];
}

#endif

@end
