//
//  WCViewController.m
//  WebViewCell
//
//  Created by zmXie on 09/02/2019.
//  Copyright (c) 2019 zmXie. All rights reserved.
//

#import "WCViewController.h"
#import "WCTableViewController.h"

@interface WCViewController ()

@end

@implementation WCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)kvoDetail:(id)sender {
    WCTableViewController *vc = [WCTableViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)fixedDetail:(id)sender {
    WCTableViewController *vc = [WCTableViewController new];
    vc.fixedHeight = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
