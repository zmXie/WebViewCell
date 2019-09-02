//
//  WCWebFixedCell.m
//  WebViewCell
//
//  Created by xzm on 2019/9/2.
//

#import "WCWebFixedCell.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+WCAdd.h"
#import "UIScrollView+WCGesturePass.h"

typedef NS_ENUM (NSUInteger, ScrollState) {
    ScrollStateEnable,
    ScrollStateDisableAtTop,
    ScrollStateDisableAtBottom,
};

@interface WCWebFixedCell ()

@property (nonatomic) BOOL isStartHandle;
@property (nonatomic) CGFloat topOfWebViewInTable;
@property (nonatomic) ScrollState scrollState;
@property (nonatomic) BOOL disableTableViewScroll;
@property (nonatomic) BOOL isAutoScrollToBottom;

@end

@implementation WCWebFixedCell

- (void)setupUI
{
    [super setupUI];
    self.tableView.wc_passFlag = YES;
    self.webView.scrollView.wc_passFlag = YES;
}

- (void)scrollToBottom
{
    self.isAutoScrollToBottom = YES;
    [self.webView.scrollView setContentOffset:CGPointMake(0, self.webView.scrollView.contentSize.height - self.webView.scrollView.height) animated:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAutoScrollToBottom = NO;
    });
}

- (void)startHandleLinkScroll
{
    if (self.isStartHandle) {
        return;
    }
    self.isStartHandle = YES;
    
    self.disableTableViewScroll = NO;
    self.scrollState = ScrollStateDisableAtTop;
    
    self.topOfWebViewInTable = [self convertPoint:self.webView.frame.origin toView:self.tableView].y;
    
    @weakify(self)
    [[RACObserve(self, disableTableViewScroll) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        self.tableView.showsVerticalScrollIndicator = ![x boolValue];
        self.webView.scrollView.showsVerticalScrollIndicator = [x boolValue];
    }];
    [[RACObserve(self.tableView, contentOffset) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        // 如果网页大小没有占一整屏幕，一直禁止滚动
        if (self.webView.height < self.tableView.height || self.isAutoScrollToBottom) {
            return;
        }
        
        if (self.disableTableViewScroll) {
            // 固定位置
            [self.tableView setContentOffset:CGPointMake(0, self.topOfWebViewInTable)];
        } else {
            CGFloat y = [x CGPointValue].y;
            if (self.scrollState == ScrollStateDisableAtTop) {
                if (y >= self.topOfWebViewInTable) {
                    self.disableTableViewScroll = YES;
                    [self.tableView setContentOffset:CGPointMake(0, self.topOfWebViewInTable)];
                    
                    self.scrollState = ScrollStateEnable;
                }
            } else if (self.scrollState == ScrollStateDisableAtBottom) {
                if (y <= self.topOfWebViewInTable) {
                    self.disableTableViewScroll = YES;
                    [self.tableView setContentOffset:CGPointMake(0, self.topOfWebViewInTable)];
                    
                    self.scrollState = ScrollStateEnable;
                }
            }
        }
    }];
    [[RACObserve(self.webView.scrollView, contentOffset) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        if (self.isAutoScrollToBottom) {
            self.disableTableViewScroll = NO;
            self.scrollState = ScrollStateDisableAtBottom;
            return;
        }
        //设置0.5偏移，防止偶尔出现临界点滑不动现象
        CGFloat y = [x CGPointValue].y;
        if (self.scrollState == ScrollStateDisableAtTop) {
            // 固定在头部位置
            [self.webView.scrollView setContentOffset:CGPointMake(0, 0.5)];
        } else if (self.scrollState == ScrollStateDisableAtBottom) {
            // 固定在底部位置
            [self.webView.scrollView setContentOffset:CGPointMake(0, self.webView.scrollView.contentSize.height - self.webView.scrollView.height - 0.5)];
        } else {
            // 向下滑动
            if (y <= 0) {
                self.scrollState = ScrollStateDisableAtTop;
                [self.webView.scrollView setContentOffset:CGPointMake(0, 0.5)];
                
                self.disableTableViewScroll = NO;
            } else if (y >= self.webView.scrollView.contentSize.height - self.webView.scrollView.height) {
                // 滑动到最底部
                self.scrollState = ScrollStateDisableAtBottom;
                [self.webView.scrollView setContentOffset:CGPointMake(0, self.webView.scrollView.contentSize.height - self.webView.scrollView.height - 0.5)];
                
                self.disableTableViewScroll = NO;
            }
        }
    }];
}

- (void)refreshWebViewHeight:(CGFloat)height
{
    if (height < self.tableView.height + 0.1) {
        // 加载的网页变小
        self.disableTableViewScroll = NO;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.height = height;
        [super refreshWebViewHeight:height];
    } else {
        // 最大限制webview高度不能超过tableview
        if (height > self.tableView.height) {
            if (!self.webView.scrollView.scrollEnabled) {
                self.webView.scrollView.scrollEnabled = YES;
                if (self.tableView.contentOffset.y >= self.topOfWebViewInTable) {
                    self.disableTableViewScroll = YES;
                    self.scrollState = ScrollStateEnable;
                }
            }
            self.webView.height = self.tableView.height;
            [super refreshWebViewHeight:self.tableView.height];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self startHandleLinkScroll];
}

@end
