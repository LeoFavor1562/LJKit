//
//  LJSelectImageViewCell.h
//  QiPaiQuan
//
//  Created by ios on 2017/10/19.
//  Copyright © 2017年 login58. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJSelectImageViewCell;
@protocol LJSelectImageViewCellDelegate <NSObject>

- (UIImage *)getAddImage;
- (UIImage *)getDeleteImage;
- (BOOL)allowsDelete;
- (void)removeImageCell:(LJSelectImageViewCell *)cell;

@end

@interface LJSelectImageViewCell : UICollectionViewCell

@property (nonatomic, weak) id<LJSelectImageViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

- (void)setSelectImage:(id)image;
- (BOOL)isShowingImage;

@end
