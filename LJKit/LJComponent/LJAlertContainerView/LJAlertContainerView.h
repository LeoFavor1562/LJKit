//
//  LJAlertContainerView.h
//  SuDian
//
//  Created by coder on 2019/5/7.
//  Copyright © 2019 DHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJAlertContainerConfig : NSObject

@property (nonatomic, assign) CGFloat animationTime;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL useAutoLayout;

@end


@interface LJAlertContainerView : UIView

- (instancetype)initWithConfig:(LJAlertContainerConfig *)config;

- (void)showInView:(UIView *)view;
- (void)hide;

@end

