//
//  UITextView+LJExtension.m
//  LJPlaceHolderDemo
//
//  Created by coder on 2019/2/26.
//  Copyright © 2019年 wang_ziwu. All rights reserved.
//

#import "UITextView+LJExtension.h"
#import <objc/runtime.h>

//swizzlng宏
#define SwizzleMethod(class, originalSelector, swizzledSelector) {\
Method originalMethod = class_getInstanceMethod(class, (originalSelector)); \
Method swizzledMethod = class_getInstanceMethod(class, (swizzledSelector)); \
if (!originalMethod || !swizzledMethod) {\
return;\
}\
if (!class_addMethod((class),                                               \
(originalSelector),                                    \
method_getImplementation(swizzledMethod),              \
method_getTypeEncoding(swizzledMethod))) {             \
method_exchangeImplementations(originalMethod, swizzledMethod);         \
} else {                                                                    \
class_replaceMethod((class),                                            \
(swizzledSelector),                                 \
method_getImplementation(originalMethod),           \
method_getTypeEncoding(originalMethod));            \
}                                                                           \
}

//placeHolder
static const void *LJ_placeHolderKey;

@interface UITextView ()

@property (nonatomic, readonly) UILabel *LJ_placeHolderLabel;

@end

@implementation UITextView (LJExtension)

+ (void)load {
    
    SwizzleMethod(self.class, NSSelectorFromString(@"layoutSubviews"), @selector(LJPlaceHolder_swizzling_layoutSubviews));
    SwizzleMethod(self.class, NSSelectorFromString(@"dealloc"), @selector(LJPlaceHolder_swizzled_dealloc));
    SwizzleMethod(self.class, NSSelectorFromString(@"setText:"), @selector(LJPlaceHolder_swizzled_setText:));
    
//    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
//                                   class_getInstanceMethod(self.class, @selector(LJPlaceHolder_swizzling_layoutSubviews)));
//    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
//                                   class_getInstanceMethod(self.class, @selector(LJPlaceHolder_swizzled_dealloc)));
//    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")),
//                                   class_getInstanceMethod(self.class, @selector(LJPlaceHolder_swizzled_setText:)));
}

#pragma mark - swizzled
- (void)LJPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self LJPlaceHolder_swizzled_dealloc];
}
- (void)LJPlaceHolder_swizzling_layoutSubviews {
    if (self.LJ_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.LJ_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.LJ_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self LJPlaceHolder_swizzling_layoutSubviews];
}
- (void)LJPlaceHolder_swizzled_setText:(NSString *)text{
    [self LJPlaceHolder_swizzled_setText:text];
    if (self.LJ_placeHolder) {
        [self updatePlaceHolder];
    }
}
#pragma mark - associated
-(NSString *)LJ_placeHolder{
    return objc_getAssociatedObject(self, &LJ_placeHolderKey);
}
-(void)setLJ_placeHolder:(NSString *)LJ_placeHolder{
    objc_setAssociatedObject(self, &LJ_placeHolderKey, LJ_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.text == nil || [self.text isEqualToString:@""]) {
        self.text = @" ";
        self.text = nil;
    }
    [self updatePlaceHolder];
}
-(UIColor *)LJ_placeHolderColor{
    return self.LJ_placeHolderLabel.textColor;
}
-(void)setLJ_placeHolderColor:(UIColor *)LJ_placeHolderColor{
    self.LJ_placeHolderLabel.textColor = LJ_placeHolderColor;
}
-(NSString *)placeholder{
    return self.LJ_placeHolder;
}
-(void)setPlaceholder:(NSString *)placeholder{
    self.LJ_placeHolder = placeholder;
}
#pragma mark - update
- (void)updatePlaceHolder{
    NSLog(@"%@", self.text);
    if (self.text.length) {
        if (self.LJ_placeHolderLabel.superview != nil) {
            [self.LJ_placeHolderLabel removeFromSuperview];
        }
        return;
    }
    self.LJ_placeHolderLabel.font = self.font?self.font:self.cacutDefaultFont;
    self.LJ_placeHolderLabel.textAlignment = self.textAlignment;
    self.LJ_placeHolderLabel.text = self.LJ_placeHolder;
    [self insertSubview:self.LJ_placeHolderLabel atIndex:0];
    
}
#pragma mark - lazzing
-(UILabel *)LJ_placeHolderLabel{
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(LJ_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(LJ_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}
- (UIFont *)cacutDefaultFont {
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}

@end
