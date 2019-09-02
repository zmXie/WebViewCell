//
//  WCWebFixedCell.h
//  WebViewCell
//
//  Created by xzm on 2019/9/2.
//

#import "WCWebViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 固定高度，完全由webview处理，避免KVO获取高度不准以及高度无限增加问题
 */
@interface WCWebFixedCell : WCWebViewCell

@end

NS_ASSUME_NONNULL_END
