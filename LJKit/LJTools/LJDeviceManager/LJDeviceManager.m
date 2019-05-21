//
//  LJDeviceManager.m
//  SuDianPlay
//
//  Created by coder on 2019/4/17.
//  Copyright © 2019年 coder. All rights reserved.
//

#import "LJDeviceManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>

//是否是iPad
#define LJS_is_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation LJImagePickerConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

static LJDeviceManager *deviceManager = nil;

@interface LJDeviceManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) LJImagePickerConfig *imagePickerConfig;

@end

@implementation LJDeviceManager

+ (id)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceManager = [[self alloc] init];
    });
    return deviceManager;
}

+ (id)alloc {
    @synchronized (self) {
        if (!deviceManager) {
            return [super alloc];
        }
    }
    return deviceManager;
}


- (void)getCameraPermissions:(void (^)(BOOL available))completion {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            completion(granted);
        }];
    }else if (authStatus == AVAuthorizationStatusAuthorized) {
        completion(YES);
    }else {
        completion(NO);
    }
}


- (void)showSourceTypeAlert:(NSArray *)sourceTypes {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    for (NSNumber *sourceType in sourceTypes) {
        UIAlertAction *action;
        if (sourceType.integerValue == UIImagePickerControllerSourceTypePhotoLibrary) {
            action = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
            }];
        }else if (sourceType.integerValue == UIImagePickerControllerSourceTypeCamera) {
            action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
            }];
        }else {
            action = [UIAlertAction actionWithTitle:@"从手机相簿选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            }];
        }
        [alertController addAction:action];
    }
    [_imagePickerConfig.actionVC presentViewController:alertController animated:YES completion:nil];
}

- (void)callImagePicker:(LJImagePickerConfig *)config {
    if (![config.actionVC isKindOfClass:[UIViewController class]]) {
        return;
    }
    _imagePickerConfig = config;
    //源类型判断
    NSMutableArray *sourceTypes = [[NSMutableArray alloc] init];
    if ((_imagePickerConfig.sourceType & 0b00000010) == LJSourceTypeCamera) {
        [sourceTypes addObject:@(UIImagePickerControllerSourceTypeCamera)];
    }
    if ((_imagePickerConfig.sourceType & 0b00000001) == LJSourceTypePhotoLibrary) {
        [sourceTypes addObject:@(UIImagePickerControllerSourceTypePhotoLibrary)];
    }
    if ((_imagePickerConfig.sourceType & 0b00000100) == LJSourceTypeSavedPhotosAlbum) {
        [sourceTypes addObject:@(UIImagePickerControllerSourceTypeSavedPhotosAlbum)];
    }
    if (sourceTypes.count == 1) {
        [self showImagePicker:[sourceTypes.firstObject integerValue]];
    }else if (sourceTypes.count > 1) {
        [self showSourceTypeAlert:sourceTypes];
    }else {
        return;
    }
    
}

- (void)checkCameraAvailable:(void (^)(BOOL available))completion {
    // 判断是否可以打开相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self getCameraPermissions:^(BOOL available) {
            completion(available);
            if (available) {
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置->相机->授权应用拍照权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:confirm];
                [alert addAction:cancel];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }];
    }else {
        completion(NO);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirm];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    
    void (^imagePickerBlock)(void) = ^ {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.allowsEditing = _imagePickerConfig.allowsEditing;
        
        if (LJS_is_iPad) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [popover presentPopoverFromRect:[_imagePickerConfig.actionView.superview convertRect:_imagePickerConfig.actionView.frame toView:nil] inView:_imagePickerConfig.actionVC.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [_imagePickerConfig.actionVC presentViewController:picker animated:YES completion:nil];
        }
    };
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self checkCameraAvailable:^(BOOL available) {
            if (available) {
                imagePickerBlock();
            }
        }];
    }else {
        imagePickerBlock();
    }
}

//选择图片回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 取出选中的图片
    UIImage *selectImage;
    if (_imagePickerConfig.allowsEditing) {
        selectImage = info[UIImagePickerControllerEditedImage];
    }else {
        selectImage = info[UIImagePickerControllerOriginalImage];
    }
    if (_imagePickerConfig.imagePickerBlock) {
        _imagePickerConfig.imagePickerBlock(selectImage);
    }
    if ([_delegate respondsToSelector:@selector(receiveImage:)]) {
        [_delegate receiveImage:[selectImage fixOrientation]];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//点击取消按钮的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)getPhotoPermissions:(void (^)(BOOL available))completion {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    if (completion) {
                        completion(YES);
                    }
                } else {
                    if (completion) {
                        completion(NO);
                    }
                }
            });
        }];
    }else if (status == PHAuthorizationStatusAuthorized) {
        if (completion) {
            completion(YES);
        }
    }else {
        if (completion) {
            completion(NO);
        }
    }
}

- (void)saveImagesToAlbum:(NSArray *)images complete:(void (^)(BOOL))completeBlock {
    [self getPhotoPermissions:^(BOOL available) {
        if (available) {
            [self saveImages:images complete:completeBlock];
        }else {
            completeBlock(NO);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置->照片->允许添加照片权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:confirm];
            [alert addAction:cancel];
            [APPDELEGATE.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)saveImages:(NSArray *)images complete:(void (^)(BOOL))completeBlock {
    NSMutableDictionary *imageMap = [[NSMutableDictionary alloc] init];
    __block NSInteger completeCount = 0;
    for (id image in images) {
        __block NSInteger index = [images indexOfObject:image];
        if ([image isKindOfClass:[UIImage class]]) {
            [imageMap setObject:image forKey:@(index)];
            completeCount++;
            [self saveImages:images imagesMap:imageMap complete:completeCount complete:completeBlock];
        }else if ([image isKindOfClass:[NSString class]]) {
            SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
            [manager downloadImageWithURL:[NSURL URLWithString:image] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (image) {
                    [imageMap setObject:image forKey:@(index)];
                    completeCount++;
                }else {
                    [imageMap setObject:error forKey:@(index)];
                }
                [self saveImages:images imagesMap:imageMap complete:completeCount complete:completeBlock];
            }];
        }else {
            [imageMap setObject:[NSError errorWithDomain:NSCocoaErrorDomain code:404 userInfo:@{@"message" : @"请求格式不正确"}] forKey:@(index)];
            completeCount++;
            [self saveImages:images imagesMap:imageMap complete:completeCount complete:completeBlock];
        }
    }
}

- (void)saveImages:(NSArray *)images imagesMap:(NSDictionary *)imagesMap complete:(NSInteger)count complete:(void (^)(BOOL))completeBlock {
    if (images.count == count) {
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < images.count; i++) {
            id image = imagesMap[@(i)];
            if ([image isKindOfClass:[UIImage class]]) {
                [imageArray addObject:image];
            }else {
                if (completeBlock) {
                    completeBlock(NO);
                    return;
                }
            }
        }
        for (UIImage *image in imageArray) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        if (completeBlock) {
            completeBlock(YES);
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        
    }else {
        
    }
}


- (void)saveVideosToAlbum:(NSArray *)videos complete:(void (^)(BOOL))completeBlock {
    NSMutableDictionary *videoMap = [[NSMutableDictionary alloc] init];
    __block NSInteger completeCount = 0;
    
    for (NSString *videoURL in videos) {
        __block NSInteger index = [videos indexOfObject:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        NSString *fullPath = [NSString stringWithFormat:@"%@/SDVideo_%@.mp4", documentsDirectory, @(currentTime)];
        NSURL *urlNew = [NSURL URLWithString:videoURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
        
        NSURLSessionDownloadTask *task =
        [manager downloadTaskWithRequest:request
                                progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                    return [NSURL fileURLWithPath:fullPath];
                                }
                       completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                           if (!error) {
                               [videoMap setObject:[filePath absoluteString] forKey:@(index)];
                           }else {
                               [videoMap setObject:@"" forKey:@(index)];
                           }
                           completeCount++;
                           [self saveVideos:videos videoMap:videoMap complete:completeCount complete:completeBlock];
                       }];
        [task resume];
    }
}

- (void)saveVideos:(NSArray *)videos videoMap:(NSDictionary *)videoMap complete:(NSInteger)count complete:(void (^)(BOOL))completeBlock {
    if (videos.count == count) {
        NSMutableArray *videoArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < videos.count; i++) {
            NSString *videoPath = videoMap[@(i)];
            if (videoPath.length > 0) {
                [videoArray addObject:videoPath];
            }else {
                if (completeBlock) {
                    completeBlock(NO);
                    return;
                }
            }
        }
        for (NSString *videoPath in videoArray) {
            NSURL *url = [NSURL URLWithString:videoPath];
            BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
            if (compatible) {
                UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
            }
        }
        if (completeBlock) {
            completeBlock(YES);
        }
    }
}

- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
    }else {
    }
}

@end
