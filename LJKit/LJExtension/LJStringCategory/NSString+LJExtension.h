//
//  NSString+LJExtension.h
//  SuDianPlay
//
//  Created by coder on 2019/3/27.
//  Copyright © 2019年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LJExtension)

@property (nonatomic, strong, readonly) NSString *safeValue;

- (NSString *)urlAddCompnentForValue:(NSString *)value key:(NSString *)key;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSInteger)LJ_bytes;

@end

