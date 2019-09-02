//
//  WCTableViewController.m
//  WebViewCell_Example
//
//  Created by xzm on 2019/9/2.
//  Copyright © 2019 zmXie. All rights reserved.
//

#import "WCTableViewController.h"
#import <WCWebViewCell.h>
#import <WCWebFixedCell.h>

@interface WCTableViewController ()

@end

@implementation WCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        WCWebViewCell * cell;
        if (self.fixedHeight) {
            cell = [WCWebFixedCell cellWithTableView:tableView];
        } else {
            cell = [WCWebViewCell cellWithTableView:tableView];
        }
        //该url会令KVO获取的高度无限增加
//        [cell setDataDic:@{@"url":@"https://weibo.com/2803301701/I1UyxmEqg?type=comme"}];
        [cell setDataDic:@{@"url":@"https://zhuanlan.zhihu.com/p/69247987"}];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @(indexPath.row).stringValue;
        return cell;
    }
}

@end

