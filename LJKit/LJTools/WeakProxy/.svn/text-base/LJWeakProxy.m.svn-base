//
//  LJWeakProxy.m
//  SuDianPlay
//
//  Created by coder on 2019/4/10.
//  Copyright © 2019年 coder. All rights reserved.
//

#import "LJWeakProxy.h"

@interface LJWeakProxy ()

@property (weak, nonatomic, readonly) id target;

@end

@implementation LJWeakProxy

- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target{
    return [[self alloc] initWithTarget:target];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [self.target methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}

@end
