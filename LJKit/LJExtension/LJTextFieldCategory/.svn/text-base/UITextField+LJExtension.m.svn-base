//
//  UITextField+LJExtension.m
//  SuDianPlay
//
//  Created by coder on 2019/4/9.
//  Copyright © 2019年 coder. All rights reserved.
//

#import "UITextField+LJExtension.h"
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

static const void *LJ_TextFieldTextLimitKey;
static const void *LJ_TextFieldBitLimitKey;
static const void *LJ_TextFieldHaveHightStringKey;

@interface UITextField () <UITextFieldDelegate>

@property (nonatomic, assign) BOOL haveHightString;

@end

@implementation UITextField (LJExtension)

+ (void)load {
    SwizzleMethod(self.class, NSSelectorFromString(@"dealloc"), @selector(LJTextField_swizzled_dealloc));
}

- (void)setHaveHightString:(BOOL)haveHightString {
    objc_setAssociatedObject(self, &LJ_TextFieldHaveHightStringKey, @(haveHightString), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)haveHightString {
    return [objc_getAssociatedObject(self, &LJ_TextFieldHaveHightStringKey) boolValue];
}

- (void)setTextLimit:(NSInteger)textLimit {
    if (textLimit >= 0) {
        objc_setAssociatedObject(self, &LJ_TextFieldTextLimitKey, @(textLimit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = self;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLimitControl:) name:UITextFieldTextDidChangeNotification object:self];
    }
}

- (NSInteger)textLimit {
    return [objc_getAssociatedObject(self, &LJ_TextFieldTextLimitKey) integerValue];
}

- (void)setBitLimit:(NSInteger)bitLimit {
    if (bitLimit > 0) {
        objc_setAssociatedObject(self, &LJ_TextFieldBitLimitKey, @(bitLimit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bitLimitControl:) name:UITextFieldTextDidChangeNotification object:self];
    }
}

- (NSInteger)bitLimit {
    return [objc_getAssociatedObject(self, &LJ_TextFieldBitLimitKey) integerValue];
}

- (void)LJTextField_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self LJTextField_swizzled_dealloc];
}

#pragma mark --textFiled改变的通知
- (void)textLimitControl:(NSNotification *)noti {
    UITextView *textView = (UITextView *)noti.object;
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        self.haveHightString = NO;
        if (self.text.length > self.textLimit) {
            UITextRange *markedRange = [self markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [self.text rangeOfComposedCharacterSequenceAtIndex:self.textLimit];
            self.text = [self.text substringToIndex:range.location];
        }
    }else {
        self.haveHightString = YES;
    }
}

- (void)bitLimitControl:(NSNotification *)noti {
    UITextView *textView = (UITextView *)noti.object;
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        self.haveHightString = NO;
        if (self.text.LJ_bytes > self.bitLimit) {
            for (NSUInteger index = self.text.length - 1; index > 0; index--) {
                NSRange range = [self.text rangeOfComposedCharacterSequenceAtIndex:index];
                if ([self.text substringToIndex:range.location].LJ_bytes <= self.bitLimit) {
                    self.text = [self.text substringToIndex:range.location];
                    break;
                }
            }
        }
    }else {
        self.haveHightString = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 解决当双击切换标点时误删除正常文字 bug
    NSString *punctuateSring = @"，。？！.@/#";
    if (range.length == 0 && string.length == 1 && [punctuateSring containsString:string] && self.text.length >= self.textLimit) {
        return NO;
    }
    return YES;
}

@end
