//
//  LJProgressView.h
//  SuDian
//
//  Created by coder on 2019/3/14.
//  Copyright © 2019年 DHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJProgressConfig : NSObject

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@end

@interface LJProgressView : UIView

@property (nonatomic, assign) CGFloat percent;

- (instancetype)initWithConfig:(LJProgressConfig *)config;

- (void)setCompleted:(NSString *)completed total:(NSString *)total percent:(CGFloat)percent;

@end

