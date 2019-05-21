//
//  NSString+LJExtension.m
//  SuDianPlay
//
//  Created by coder on 2019/3/27.
//  Copyright © 2019年 coder. All rights reserved.
//

#import "NSString+LJExtension.h"

static NSString *const nameKey = @"LJExtensionSafeValueKey";

@implementation NSString (LJExtension)

- (NSString *)safeValue {
    if (self == nil || [self isKindOfClass:[NSNull class]]) {
        return @"";
    }else {
        return self;
    }
}

- (NSString *)urlAddCompnentForValue:(NSString *)value key:(NSString *)key {
    NSMutableString *string = [[NSMutableString alloc] initWithString:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    @try {
        NSRange range = [string rangeOfString:@"?"];
        if (range.location != NSNotFound) {//找到了
            //如果?是最后一个直接拼接参数
            if (string.length == (range.location + range.length)) {
                string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, value]];
            }else{ //如果不是最后一个需要加&
                if([string hasSuffix:@"&"]){//如果最后一个是&,直接拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, value]];
                }else{//如果最后不是&,需要加&后拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
                }
            }
        }else {//没找到
            if ([string hasSuffix:@"&"]){//如果最后一个是&,去掉&后拼接
                string = (NSMutableString *)[string substringToIndex:string.length - 1];
            }
            string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"?%@=%@", key, value]];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return string.copy;
}

- (NSString *)URLEncodedString {
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (NSString *)URLDecodedString {
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSInteger)LJ_bytes {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *da = [self dataUsingEncoding:enc];
    return [da length];
}

@end
