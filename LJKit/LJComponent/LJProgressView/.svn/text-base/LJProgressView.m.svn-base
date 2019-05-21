//
//  LJProgressView.m
//  SuDian
//
//  Created by coder on 2019/3/14.
//  Copyright © 2019年 DHK. All rights reserved.
//

#import "LJProgressView.h"

@implementation LJProgressConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor clearColor];
        _foregroundColor = [UIColor redColor];
        _lineWidth = 1;
    }
    return self;
}

@end

@interface LJProgressView ()

@property (nonatomic, strong) LJProgressConfig *config;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *completedLabel;
@property (nonatomic, strong) CAShapeLayer *totalProgressLayer;
@property (nonatomic, strong) CAShapeLayer *completedProgressLayer;

@end

@implementation LJProgressView

- (instancetype)initWithConfig:(LJProgressConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.layer.masksToBounds = YES;
    
    _totalProgressLayer = [[CAShapeLayer alloc] init];
    _totalProgressLayer.fillColor = [UIColor clearColor].CGColor;
    _totalProgressLayer.strokeColor = _config.backgroundColor.CGColor;
    _totalProgressLayer.lineCap = kCALineCapRound;
    _totalProgressLayer.lineJoin = kCALineJoinRound;
    _totalProgressLayer.lineWidth = _config.lineWidth;
    [self.layer addSublayer:_totalProgressLayer];
    
    _completedProgressLayer = [[CAShapeLayer alloc] init];
    _completedProgressLayer.fillColor = [UIColor clearColor].CGColor;
    _completedProgressLayer.strokeColor = _config.foregroundColor.CGColor;
    _completedProgressLayer.lineCap = kCALineCapRound;
    _completedProgressLayer.lineJoin = kCALineJoinRound;
    _completedProgressLayer.lineWidth = _config.lineWidth;
    _completedProgressLayer.strokeEnd = 0.0;
    [self.layer addSublayer:_completedProgressLayer];
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.font = [UIFont systemFontOfSize:11];
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.textColor = mainWhiteColor;
    _totalLabel.text = @"";
    _totalLabel.hidden = YES;
    [self addSubview:_totalLabel];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(_config.lineWidth / -2);
        make.centerY.equalTo(self);
    }];
    
    _completedLabel = [[UILabel alloc] init];
    _completedLabel.font = [UIFont systemFontOfSize:11];
    _completedLabel.textAlignment = NSTextAlignmentCenter;
    _completedLabel.textColor = mainWhiteColor;
    _completedLabel.text = @"";
    _completedLabel.hidden = YES;
    [self addSubview:_completedLabel];
    [_completedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(_config.lineWidth / 2);
        make.centerY.equalTo(self);
    }];
}

- (void)updatePath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle  = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path moveToPoint:CGPointMake(_config.lineWidth / 2.0, self.bounds.size.height / 2.0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - _config.lineWidth / 2.0, self.bounds.size.height / 2.0)];
    [path stroke];
    _totalProgressLayer.frame = self.bounds;
    _totalProgressLayer.path = path.CGPath;
    _completedProgressLayer.frame = self.bounds;
    _completedProgressLayer.path = path.CGPath;
    [self updateProgress];
}

- (void)setPercent:(CGFloat)percent {
    if (percent == _percent) {
        return;
    }
    if (percent > 1) {
        _percent = 1;
    }else if (percent < 0) {
        _percent = 0 ;
    }else {
        _percent = percent;
    }
    [self updateProgress];
}

- (void)setCompleted:(NSString *)completed total:(NSString *)total percent:(CGFloat)percent {
    if (!completed) {
        _completedLabel.hidden = YES;
    }else {
        _completedLabel.hidden = NO;
        _completedLabel.text = completed;
    }
    
    if (!total) {
        _totalLabel.hidden = YES;
    }else {
        _totalLabel.hidden = NO;
        _totalLabel.text = total;
    }
    
    [self setPercent:percent];
}

- (void)updateProgress {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    _completedProgressLayer.strokeEnd = _percent;
    [CATransaction commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updatePath];
}

@end
