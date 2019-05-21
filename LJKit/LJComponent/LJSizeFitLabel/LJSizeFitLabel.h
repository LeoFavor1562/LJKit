//
//  LJSizeFitLabel.h
//  QiPaiQuan
//
//  Created by ios on 2017/9/26.
//  Copyright © 2017年 login58. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJSizeFitLabel : UILabel

- (instancetype)initWithEdge:(UIEdgeInsets)edgeInsets;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end
