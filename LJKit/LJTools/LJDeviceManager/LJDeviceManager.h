//
//  LJDeviceManager.h
//  SuDianPlay
//
//  Created by coder on 2019/4/17.
//  Copyright © 2019年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LJSourceType) {
    LJSourceTypeNone = 0,
    LJSourceTypePhotoLibrary = 1 << 0,
    LJSourceTypeCamera = 1 << 1,
    LJSourceTypeSavedPhotosAlbum = 1 << 2,
};

@interface LJImagePickerConfig : NSObject

//@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
@property (nonatomic, assign) LJSourceType sourceType;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, weak) UIViewController *actionVC;
@property (nonatomic, weak) UIView *actionView;
@property (nonatomic, copy) void (^imagePickerBlock)(UIImage *image);

@end

@protocol LJDeviceProtocol <NSObject>

@optional

- (void)receiveImage:(UIImage *)image;

- (void)images:(NSArray *)images savedSuccess:(BOOL)success;
- (void)videos:(NSArray *)videos savedSuccess:(BOOL)success;

@end

@interface LJDeviceManager : NSObject

@property (nonatomic, weak) id<LJDeviceProtocol> delegate;

+ (id)shareManager;

- (void)callImagePicker:(LJImagePickerConfig *)config;

- (void)saveImagesToAlbum:(NSArray *)images complete:(void(^)(BOOL complete))completeBlock;
- (void)saveVideosToAlbum:(NSArray *)videos complete:(void(^)(BOOL complete))completeBlock;

@end


