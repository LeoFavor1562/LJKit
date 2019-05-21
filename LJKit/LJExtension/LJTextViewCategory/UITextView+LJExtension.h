//
//  UITextView+LJExtension.h
//  ZWPlaceHolderDemo
//
//  Created by coder on 2019/2/26.
//  Copyright © 2019年 wang_ziwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (LJExtension)

#pragma mark --placeholer
/**
 *  UITextView+placeholder
 */
@property (nonatomic, copy) NSString *LJ_placeHolder;
/**
 *  保证外部读取正常
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  placeHolder颜色
 */
@property (nonatomic, strong) UIColor *LJ_placeHolderColor;


@end
