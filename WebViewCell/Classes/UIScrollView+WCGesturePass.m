//
//  UIScrollView+WCGesturePass.m
//  WebViewCell
//
//  Created by xzm on 2019/9/2.
//

#import "UIScrollView+WCGesturePass.h"
#import <objc/runtime.h>

@implementation UIScrollView (WCGesturePass)

- (BOOL)wc_passFlag
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWc_passFlag:(BOOL)wc_passFlag
{
    objc_setAssociatedObject(self, @selector(wc_passFlag), @(wc_passFlag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    if ([view isKindOfClass:[UIScrollView class]]) {
        return [(UIScrollView *)view wc_passFlag];
    }
    return NO;
}

@end
