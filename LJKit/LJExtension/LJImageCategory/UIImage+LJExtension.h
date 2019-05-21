//
//  UIImage+LJExtension.h
//  SuDian
//
//  Created by coder on 2019/2/26.
//  Copyright © 2019年 DHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LJExtension)

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)fixOrientation;

@end

