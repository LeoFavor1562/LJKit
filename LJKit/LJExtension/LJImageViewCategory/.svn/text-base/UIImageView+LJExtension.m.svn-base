//
//  UIImageView+LJExtension.m
//  QiPaiQuan
//
//  Created by ios on 2017/1/13.
//  Copyright © 2017年 login58. All rights reserved.
//

#import "UIImageView+LJExtension.h"

//屏幕宽
#define LJE_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
//屏幕高
#define LJE_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

@implementation UIImageView (LJExtension)

- (void)showLargeImage {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *bgView = [[UIView alloc] initWithFrame:window.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    [window addSubview:bgView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:bgView.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    //设置代理
    scrollView.delegate = self;
    //设置最小缩放比例
    scrollView.minimumZoomScale = 1;
    //设置最大缩放比例
    scrollView.maximumZoomScale = 2;
    scrollView.userInteractionEnabled = YES;
    [bgView addSubview:scrollView];
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLargeImage:)];
    //设置手势点击数,双击：点2下
    hideTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:hideTap];
    
    UITapGestureRecognizer *scaleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleTap:)];
    //设置手势点击数,双击：点2下
    scaleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:scaleTap];
    
    //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
    [hideTap requireGestureRecognizerToFail:scaleTap];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.image;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    
    if (imageView.image) {
        //判断首先缩放的值
        float scaleX = LJE_SCREEN_WIDTH / imageView.image.size.width;
        float scaleY = LJE_SCREEN_HEIGHT / imageView.image.size.height;
        
        //倍数小的，先到边缘
        
        if (scaleX > scaleY) {
            //Y方向先到边缘
            float imgViewWidth = imageView.image.size.width * scaleY;
            
            imageView.frame = (CGRect){LJE_SCREEN_WIDTH / 2 - imgViewWidth / 2, 0, imgViewWidth, LJE_SCREEN_HEIGHT};
        }else {
            //X先到边缘
            float imgViewHeight = imageView.image.size.height * scaleX;
            
            imageView.frame = (CGRect){0, LJE_SCREEN_HEIGHT / 2 - imgViewHeight / 2, LJE_SCREEN_WIDTH, imgViewHeight};
        }
    }
    
    CGRect finalFrame = bgView.bounds;//imageView.frame;
    
//    scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.width);
    
    CGRect oldRect = [self.superview convertRect:self.frame toView:nil];
    imageView.frame = oldRect;
    bgView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        bgView.alpha = 1.0;
        imageView.frame = finalFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideLargeImage:(UITapGestureRecognizer *)tap {
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    UIView *bgView = scrollView.superview;
    UIImageView *imageView = [scrollView.subviews firstObject];
    CGRect oldRect = [self.superview convertRect:self.frame toView:nil];
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.zoomScale = 1.0;
        bgView.alpha = 0.0;
        imageView.frame = oldRect;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}

- (void)scaleTap:(UITapGestureRecognizer *)tap {
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    if(scrollView.zoomScale > 1.0){
        [scrollView setZoomScale:1.0 animated:YES];
    }else{
        CGRect zoomRect = [self zoomRectForScale:2.0 withCenter:[tap locationInView:tap.view]];
        [scrollView zoomToRect:zoomRect animated:YES];
//        [scrollView setZoomScale:2.0 animated:YES];
    }
}

#pragma mark - 缩放大小获取方法
- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
    UIScrollView *scrollView = window.subviews.lastObject;
    //大小
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width = [scrollView frame].size.width / scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width / 2;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2;
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews.firstObject;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

@end
