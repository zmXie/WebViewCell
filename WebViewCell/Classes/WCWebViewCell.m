//
//  WCWebViewCell.m
//  WebViewCell
//
//  Created by xzm on 2019/9/2.
//

#import "WCWebViewCell.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#define SCREENWIDTH  [[UIScreen mainScreen] bounds].size.width

@implementation WCWebViewCell
- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifier = NSStringFromClass([self class]);
    WCWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.tableView = tableView;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.separatorInset = UIEdgeInsetsMake(0, SCREENWIDTH, 0, 0);
   
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
    _webView.navigationDelegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.scrollEnabled = NO;
    [self.contentView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(0);
        make.left.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0).priorityMedium();
    }];
    
    @weakify(self)
    [[[[RACObserve(self.webView.scrollView,contentSize) distinctUntilChanged] skip:1]throttle:0.5] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"KVO:%@",x);
        CGFloat h = [x CGSizeValue].height;
        if (h <= 0) return;
        [self refreshWebViewHeight:h];
    }];
}

- (void)setDataDic:(NSDictionary *)dic
{
    NSString *contentUrl = dic[@"url"]?:@"";
    
    if (![_webView.URL.absoluteString isEqualToString:contentUrl]) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentUrl]]];
    }
}

- (void)refreshWebViewHeight:(CGFloat)height
{
    @try {
        if ([self.tableView.dataSource numberOfSectionsInTableView:self.tableView]) {
            [UIView performWithoutAnimation:^{
                [self.tableView beginUpdates];
                [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
                [self.tableView endUpdates];
            }];
        }
    } @catch (NSException *exception) {
        
    }
}

#pragma mark -- WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    // 点击链接跳转网页
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        NSString *url = [navigationAction.request.URL absoluteString];
//        PCGotoWebVC(url);
        policy = WKNavigationActionPolicyCancel;
    }
    decisionHandler(policy);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}


@end
