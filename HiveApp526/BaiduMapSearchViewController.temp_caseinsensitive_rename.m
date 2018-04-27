//
//  BaiDuMapSearchViewController.m
//  HiveApp526
//
//  Created by maybee on 2018/3/28.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "BaiDuMapSearchViewController.h"

@interface BaiduMapSearchViewController ()

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *headView;

@end

@implementation BaiduMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}
- (void)makeUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}



@end
