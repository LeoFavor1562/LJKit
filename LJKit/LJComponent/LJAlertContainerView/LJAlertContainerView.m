//
//  LJAlertContainerView.m
//  SuDian
//
//  Created by coder on 2019/5/7.
//  Copyright © 2019 DHK. All rights reserved.
//

#import "LJAlertContainerView.h"

@implementation LJAlertContainerConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.animationTime = 0.25;
        self.contentView = nil;
    }
    return self;
}

@end

@interface LJAlertContainerView ()

@property (nonatomic, strong) LJAlertContainerConfig *config;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) NSInteger containerHeight;

@end

@implementation LJAlertContainerView

- (instancetype)initWithConfig:(LJAlertContainerConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_containerView];
    [_containerView addSubview:_config.contentView];
    if (_config.useAutoLayout) {
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        [_config.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top);
            make.left.equalTo(self.containerView.mas_left);
            make.bottom.equalTo(self.containerView.mas_bottom);
            make.right.greaterThanOrEqualTo(self.containerView.mas_right);
        }];
    }else {
        CGFloat containerWidth = _config.contentView.frame.size.width;
        CGFloat containerHeight = _config.contentView.frame.size.height;
        [_config.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top);
            make.left.equalTo(self.containerView.mas_left);
            make.bottom.equalTo(self.containerView.mas_bottom);
            make.width.mas_equalTo(containerWidth);
            make.height.mas_equalTo(containerHeight);
        }];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _containerHeight = self.containerView.frame.size.height;
}

- (void)showInView:(UIView *)view {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    UIView *showView;
    if (view) {
        showView = view;
    }else {
        showView = [UIApplication sharedApplication].keyWindow;
    }
    [showView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(showView);
    }];
    
    self.backgroundColor = [UIColor clearColor];
    self.containerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, _containerHeight, 0);
    [UIView animateWithDuration:_config.animationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.containerView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [UIView animateWithDuration:_config.animationTime animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, _containerHeight, 0);
    } completion:^(BOOL finished) {
        self.containerView.layer.transform = CATransform3DIdentity;
        [self removeFromSuperview];
    }];
}

@end
