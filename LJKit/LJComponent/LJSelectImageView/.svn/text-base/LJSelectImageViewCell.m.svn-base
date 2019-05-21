//
//  LJSelectImageViewCell.m
//  QiPaiQuan
//
//  Created by ios on 2017/10/19.
//  Copyright © 2017年 login58. All rights reserved.
//

#import "LJSelectImageViewCell.h"

@interface LJSelectImageViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (nonatomic, weak) id image;

@end

@implementation LJSelectImageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectImageView.layer.masksToBounds = YES;
}

- (void)setSelectImage:(id)image {
    _image = image;
    if (image) {
        if ([image isKindOfClass:[UIImage class]]) {
            _selectImageView.image = image;
        }else if ([image isKindOfClass:[NSString class]]) {
            UIImage  *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(100, 100)];
            [_selectImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:placeholderImage];
        }else {
            return;
        }
        if ([self.delegate allowsDelete]) {
            [_removeBtn setImage:[self.delegate getDeleteImage] forState:UIControlStateNormal];
            _removeBtn.hidden = NO;
        }else {
            _removeBtn.hidden = YES;
        }
    }else {
        _selectImageView.image = [self.delegate getAddImage];
        _removeBtn.hidden = YES;
    }
}

- (BOOL)isShowingImage {
    if (_image) {
        return YES;
    }else {
        return NO;
    }
}

- (IBAction)removeBtnClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(removeImageCell:)]) {
        [_delegate removeImageCell:self];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (!_image) {
        if (highlighted) {
            _selectImageView.image = [self.delegate getAddImage];
        }else {
            _selectImageView.image = [self.delegate getAddImage];
        }
    }
}


@end
