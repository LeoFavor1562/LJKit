//
//  SDTagView.m
//  SuDian
//
//  Created by coder on 2019/4/26.
//  Copyright © 2019年 DHK. All rights reserved.
//

#import "LJTagView.h"

@implementation LJTagViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectZero;
        self.contentInsert = UIEdgeInsetsZero;
        self.segmentSize = CGSizeMake(10, 10);
        self.backgroundColor = [UIColor clearColor];
        
        self.selections = nil;
        self.disabledSelections = nil;
        
        self.canCancel = YES;
    }
    return self;
}

@end

@interface LJTagView ()

@property (nonatomic, strong) LJTagViewConfig *config;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIButton *currentItem;

@property (nonatomic, assign) CGFloat tagViewHeight;

@end

@implementation LJTagView

- (instancetype)initWithConfig:(LJTagViewConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void)setConfig:(LJTagViewConfig *)config {
    if (!config) {
        return;
    }else {
        _config = config;
    }
    if (CGRectIsEmpty(_config.frame)) {
        self.frame = _config.frame;
    }
    self.backgroundColor = _config.backgroundColor;
    
    if (_config.titleBlock) {
        _titleLabel = _config.titleBlock();
        [self addSubview:_titleLabel];
    }
    
    if (_config.itemBlock) {
        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
        for (NSString *itemStr in _config.selections) {
            UIButton *item = _config.itemBlock(itemStr);
            [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
            [itemsArray addObject:item];
        }
        _items = itemsArray.copy;
    }
    [self updateWithDisabledItems:_config.disabledSelections];
}

- (void)updateFrame {
    if (_titleLabel) {
        _titleLabel.frame = CGRectMake(_config.contentInsert.left, _config.contentInsert.top, self.frame.size.width - _config.contentInsert.left  - _config.contentInsert.right, _titleLabel.font.pointSize);
    }else {
        
    }
    UIButton *lastItem;
    CGFloat itemHeight = 0.0;
    for (UIButton *item in _items) {
        if (!lastItem) {
            item.frame = CGRectMake(_config.contentInsert.left, CGRectGetMaxY(_titleLabel.frame) + _config.segmentSize.height, 0, 0);
            [item sizeToFit];
            itemHeight = item.frame.size.height;
        }else {
            CGSize itemSize = [item sizeThatFits:CGSizeMake(0, itemHeight)];
            if ((_config.segmentSize.width + itemSize.width + _config.contentInsert.right) <= self.frame.size.width - CGRectGetMaxX(lastItem.frame)) {//一行能放下
                item.frame = CGRectMake(CGRectGetMaxX(lastItem.frame) + _config.segmentSize.width, lastItem.frame.origin.y, itemSize.width, itemHeight);
            }else {//一行放不下
                item.frame = CGRectMake(_config.contentInsert.left, CGRectGetMaxY(lastItem.frame) + _config.segmentSize.height, itemSize.width, itemHeight);
            }
        }
        lastItem = item;
    }
    if (_config.frame.size.width != 0) {
        self.frame = CGRectMake(_config.frame.origin.x, _config.frame.origin.y, _config.frame.size.width, CGRectGetMaxY(lastItem.frame) + _config.contentInsert.bottom);
    }
    _tagViewHeight = CGRectGetMaxY(lastItem.frame) + _config.contentInsert.bottom;
    
    if (self.translatesAutoresizingMaskIntoConstraints) {
        CGRect oldFrame = self.frame;
        oldFrame.size.height = _tagViewHeight;
        self.frame = oldFrame;
    }else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_tagViewHeight);
        }];
    }
}

- (void)itemClicked:(UIButton *)btn {
    UIButton *lastItem = _currentItem;
    if ([_currentItem isEqual:btn]) {
        if (_config.canCancel) {
            _currentItem.selected = NO;
            _currentItem = nil;
        }else {
            return;
        }
    }else {
        _currentItem.selected = NO;
        _currentItem = btn;
        _currentItem.selected = YES;
    }
    if ([_delegate respondsToSelector:@selector(didTouchTag:lastTag:)]) {
        [_delegate didTouchTag:_currentItem.titleLabel.text lastTag:lastItem.titleLabel.text];
    }
    if ([_delegate respondsToSelector:@selector(selectItem:lastItem:InTagView:)]) {
        [_delegate selectItem:_currentItem lastItem:lastItem InTagView:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateFrame];
}

- (NSString *)currentTitle {
    return self.titleLabel.text;
}

- (NSString *)currentContent {
    return self.currentItem.titleLabel.text;
}

- (CGFloat)tagViewHeight {
    [self layoutIfNeeded];
    return _tagViewHeight;
}

- (void)resetItems {
    for (UIButton *item in _items) {
        item.enabled = YES;
        item.selected = NO;
    }
}

- (void)updateWithEnabledItems:(NSArray *)enableItems {
    if (enableItems) {
        for (UIButton *item in _items) {
            if ([enableItems containsObject:item.titleLabel.text]) {
                item.enabled = YES;
            }else {
                item.enabled = NO;
                item.selected = NO;
            }
        }
    }
}

- (void)updateWithDisabledItems:(NSArray *)disabledItems {
    if (disabledItems) {
        for (UIButton *item in _items) {
            if ([disabledItems containsObject:item.titleLabel.text]) {
                item.enabled = NO;
                item.selected = NO;
            }else {
                item.enabled = YES;
            }
        }
    }
}

@end




/*
 LJTagViewConfig *config = [[LJTagViewConfig alloc] init];
 config.frame = CGRectMake(0, 200, self.view.frame.size.width, 0);
 config.contentInsert = UIEdgeInsetsMake(10, 10, 10, 10);
 config.segmentSize = CGSizeMake(20, 20);
 config.backgroundColor = [UIColor blackColor];
 config.selections = @[@"123", @"456", @"asdfsfsdfsdfasfasdf", @"@", @"哈好施工方v", @"哦爱护我诶工农搜的浓缩", @"#弄202（（*将结果H（9t9G("];
 config.disabledSelections = @[@"456", @"#弄202（（*将结果H（9t9G("];
 config.titleBlock = ^UILabel *{
 UILabel *label = [[UILabel alloc] init];
 label.backgroundColor = [UIColor clearColor];
 label.text = @"标题";
 label.textColor = [UIColor whiteColor];
 label.font = [UIFont systemFontOfSize:15];
 return label;
 };
 config.itemBlock = ^UIButton *(NSString *itemStr) {
 UIButton *item = [[UIButton alloc] init];
 item.layer.cornerRadius = 3;
 item.layer.masksToBounds = YES;
 [item setTitle:itemStr forState:UIControlStateNormal];
 [item setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
 [item setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
 [item setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateSelected];
 [item setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateSelected | UIControlStateHighlighted];
 [item setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateDisabled];
 return item;
 };
 
 LJTagView *tagView = [[LJTagView alloc] initWithConfig:config];
 [self.view addSubview:tagView];
 */
