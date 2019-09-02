//
//  WCWebViewCell.h
//  WebViewCell
//
//  Created by xzm on 2019/9/2.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 KVO计算高度来自适应
 */
@interface WCWebViewCell : UITableViewCell<WKNavigationDelegate, UIWebViewDelegate>

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,  weak) UITableView *tableView;

- (void)setupUI;
- (void)setDataDic:(NSDictionary *)dic;
- (void)refreshWebViewHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
