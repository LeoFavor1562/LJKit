//
//  LJSelectImageView.h
//  QiPaiQuan
//
//  Created by ios on 2017/10/18.
//  Copyright © 2017年 login58. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJSelectImageConfig : NSObject

@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, strong) UIColor *viewBGColor;
@property (nonatomic, assign) NSUInteger maxImageCount;
@property (nonatomic, assign) UIEdgeInsets viewEdge;
@property (nonatomic, assign) CGFloat itemInterval;
@property (nonatomic, assign) CGFloat lineInterval;
@property (nonatomic, assign) NSUInteger cellNumberInLine;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, assign) BOOL allowsDelete;

@property (nonatomic, strong) UIImage *addImage;
@property (nonatomic, strong) UIImage *addImageHighlighted;
@property (nonatomic, strong) UIImage *deleteImage;

@property (nonatomic, strong) NSArray *originImages;

@end

@protocol LJSelectImageViewDelegate <NSObject>

- (void)imageCountDidChanged:(NSInteger)count;

@end

@interface LJSelectImageView : UIView

@property (nonatomic, weak) id<LJSelectImageViewDelegate> delegate;

- (instancetype)initWithConfig:(LJSelectImageConfig *)config;

- (BOOL)addImages:(NSArray *)images;
- (NSInteger)imageCount;
- (NSArray *)getImagesFromView;

@end
