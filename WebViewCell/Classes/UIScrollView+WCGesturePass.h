//
//  UIScrollView+WCGesturePass.h
//  WebViewCell
//
//  Created by xzm on 2019/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (WCGesturePass)

/**
 手势穿透
 */
@property (nonatomic, assign) BOOL wc_passFlag;

@end

NS_ASSUME_NONNULL_END
