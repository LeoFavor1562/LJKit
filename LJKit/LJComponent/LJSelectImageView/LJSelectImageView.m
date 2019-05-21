//
//  LJSelectImageView.m
//  QiPaiQuan
//
//  Created by ios on 2017/10/18.
//  Copyright © 2017年 login58. All rights reserved.
//

#import "LJSelectImageView.h"
#import "LJSelectImageViewCell.h"
#import "UIImageView+LJExtension.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

//是否是iPad
#define LJS_is_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation LJSelectImageConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewFrame = CGRectZero;
        _viewBGColor = [UIColor clearColor];
        _maxImageCount = 1;
        _viewEdge = UIEdgeInsetsZero;
        _itemInterval = 0;
        _lineInterval = 0;
        _cellNumberInLine = 1;
        _allowsEditing = NO;
        _allowsDelete = YES;
        _addImage = [UIImage imageNamed:@"add_picture_normal"];
        _addImageHighlighted = [UIImage imageNamed:@"add_picture_normal"];
        _deleteImage = [UIImage imageNamed:@"add_picture_delete"];
    }
    return self;
}

@end

@interface LJSelectImageView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LJSelectImageViewCellDelegate>

@property (nonatomic, strong) LJSelectImageConfig *config;
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UICollectionViewCell *tmpCell;

@end

@implementation LJSelectImageView

- (instancetype)initWithConfig:(LJSelectImageConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        [self appendImages:_config.originImages];
        [self createUI];
    }
    return self;
}

- (void)appendImages:(NSArray *)images {
    if (images.count > 0) {
//        _imageArray = [[NSMutableArray alloc] initWithArray:[_config.originImages subarrayWithRange:NSMakeRange(0, MIN(_config.maxImageCount, _config.originImages.count))]];
        NSInteger imageCount = 0;
        for (id image in images) {
            if ([image isKindOfClass:[UIImage class]] || [image isKindOfClass:[NSString class]]) {
                [self.imageArray addObject:image];
                [self changeImageCount];
                imageCount++;
            }
            if (imageCount == _config.maxImageCount) {
                break;
            }
        }
    }
}


- (void)createUI {
    self.frame = _config.viewFrame;
    self.backgroundColor = _config.viewBGColor;
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = _config.lineInterval;
    _flowLayout.minimumInteritemSpacing = _config.itemInterval;
    _flowLayout.sectionInset = _config.viewEdge;
    _imageCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _imageCollectionView.backgroundColor = [UIColor clearColor];
    _imageCollectionView.delegate = self;
    _imageCollectionView.dataSource = self;
    _imageCollectionView.scrollEnabled = NO;
    [self addSubview:_imageCollectionView];
    
//    [_imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    [_imageCollectionView registerNib:[UINib nibWithNibName:@"LJSelectImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"LJSelectImageViewCell"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadView];
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(_imageCollectionView.collectionViewLayout.collectionViewContentSize.height);
//    }];
}

- (void)reloadView {
    [_imageCollectionView reloadData];
    CGRect viewFrame = self.frame;
    viewFrame.size.height = _imageCollectionView.collectionViewLayout.collectionViewContentSize.height;
    self.frame = viewFrame;
    _imageCollectionView.frame = self.bounds;
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(_imageCollectionView.collectionViewLayout.collectionViewContentSize.height);
//    }];
}

- (BOOL)addImages:(NSArray *)images {
    if (_imageArray.count >= _config.maxImageCount) {
        return NO;
    }else {
        [self appendImages:images];
        [self reloadView];
        return YES;
    }
}

- (NSInteger)imageCount {
    return _imageArray.count;
}

- (NSArray *)getImagesFromView {
    return _imageArray;
}

- (void)addImageClick:(NSIndexPath *)indexPath {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"添加图片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self callCamera];
    }];
    UIAlertAction *photoAlbum = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancel  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:camera];
    [actionSheet addAction:photoAlbum];
    [actionSheet addAction:cancel];
    [self.viewController presentViewController:actionSheet animated:YES completion:nil];
    
    if (LJS_is_iPad) {
        UIPopoverPresentationController *popover = actionSheet.popoverPresentationController;
        if (popover) {
            _tmpCell = [_imageCollectionView cellForItemAtIndexPath:indexPath];
            popover.sourceView = _tmpCell;
            popover.sourceRect = _tmpCell.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)type {
    // 1.创建图片选择控制器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    // 2.设置控制器打开数据的类型(相册/相机/本地图片)
    picker.sourceType = type;
    // 3.开启编辑模式, 允许用户编辑图片
    picker.allowsEditing = _config.allowsEditing;
    
    if (LJS_is_iPad) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [popover presentPopoverFromRect:[_imageCollectionView convertRect:_tmpCell.frame toView:nil] inView:self.viewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else {
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 取出选中的图片
    UIImage *selectImage;
    if (_config.allowsEditing) {
        selectImage = info[UIImagePickerControllerEditedImage];
    }else {
        selectImage = info[UIImagePickerControllerOriginalImage];
    }
    [self addImage:[self fixOrientation:selectImage]];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//点击取消按钮的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addImage:(UIImage *)image {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    [_imageArray addObject:image];
    [self changeImageCount];
    [self reloadView];
    [self.viewController.view endEditing:YES];
}

#pragma mark --LJSelectImageViewCellDelegate
- (UIImage *)getAddImage {
    return self.config.addImage;
}

- (UIImage *)getDeleteImage {
    return self.config.deleteImage;
}

- (void)removeImageCell:(id)cell {
    PopupAlterView *alert = [[PopupAlterView alloc] initWithFrame:APPDELEGATE.window andTitle:@"确定要删除照片吗？" sureTitle:@"确定" closeTitle:@"取消"];
    alert.block = ^{
        if ([cell isKindOfClass:[LJSelectImageViewCell class]]) {
            NSIndexPath *indexPath = [_imageCollectionView indexPathForCell:cell];
            [_imageArray removeObjectAtIndex:indexPath.row];
            [self changeImageCount];
            [self reloadView];
        }
        [AppTools showToastUseMBHub:APPDELEGATE.window showText:@"删除成功"];
    };
    [alert showPopViewAnimate:YES];
}

- (BOOL)allowsDelete {
    return _config.allowsDelete;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_config.allowsDelete) {
        return (_imageArray.count + 1) > _config.maxImageCount ? _config.maxImageCount : _imageArray.count + 1;
    }else {
        return (_imageArray.count) > _config.maxImageCount ? _config.maxImageCount : _imageArray.count;
    }
}
//cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJSelectImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LJSelectImageViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row >= _imageArray.count) {
        [cell setSelectImage:nil];
    }else {
        [cell setSelectImage:_imageArray[indexPath.row]];
    }
    return cell;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.viewController.view endEditing:YES];
    if (indexPath.row >= _imageArray.count) {//添加
        [self addImageClick:indexPath];
    }else {//查看
        LJSelectImageViewCell *cell = (LJSelectImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.selectImageView showLargeImage];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        size = (self.frame.size.width - _config.viewEdge.left - _config.viewEdge.right - (_config.cellNumberInLine - 1) * _flowLayout.minimumInteritemSpacing) / _config.cellNumberInLine;
    }else {
        size = (self.frame.size.height - _config.viewEdge.top - _config.viewEdge.bottom - (_config.cellNumberInLine - 1) * _flowLayout.minimumInteritemSpacing) / _config.cellNumberInLine;
    }
    return CGSizeMake(size, size);
}

#pragma mark --获得父VC
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


/**
 *  调用系统相机
 */
- (void)callCamera {
    //判断是否已授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置->隐私->相机授权应用拍照权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:confirm];
            [alert addAction:cancel];
            [self.viewController presentViewController:alert animated:YES completion:nil];
            return ;
        }
    }
    // 判断是否可以打开相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirm];
        [self.viewController presentViewController:alert animated:YES completion:nil];
    }
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (void)changeImageCount {
    if ([_delegate respondsToSelector:@selector(imageCountDidChanged:)]) {
        [_delegate imageCountDidChanged:_imageArray.count];
    }
}








@end
