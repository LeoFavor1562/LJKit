//
//  SDTagView.h
//  SuDian
//
//  Created by coder on 2019/4/26.
//  Copyright © 2019年 DHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJTagViewConfig : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) UIEdgeInsets contentInsert;
//width为item横向间隔，height为item纵向间隔
@property (nonatomic, assign) CGSize segmentSize;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, copy) NSArray *selections;
@property (nonatomic, copy) NSArray *disabledSelections;

//titie样式，不要设置frame，设置了也会被覆盖
@property (nonatomic, copy) UILabel *(^titleBlock)(void);
//按钮样式，不要设置点击事件
@property (nonatomic, copy) UIButton *(^itemBlock)(NSString *itemStr);

@property (nonatomic, assign) BOOL canCancel;

@end

@class LJTagView;

@protocol LJTagViewProtocol <NSObject>

@optional
- (void)didTouchTag:(NSString *)tag lastTag:(NSString *)lastTag;
- (void)selectItem:(UIButton *)item lastItem:(UIButton *)lastItem InTagView:(LJTagView *)tagView;

@end

@interface LJTagView : UIView

@property (nonatomic, weak) id<LJTagViewProtocol> delegate;

- (instancetype)initWithConfig:(LJTagViewConfig *)config;

- (void)resetItems;
- (void)updateWithEnabledItems:(NSArray *)enableItems;
- (void)updateWithDisabledItems:(NSArray *)disabledItems;

- (NSString *)currentTitle;
- (NSString *)currentContent;
- (CGFloat)tagViewHeight;

@end

