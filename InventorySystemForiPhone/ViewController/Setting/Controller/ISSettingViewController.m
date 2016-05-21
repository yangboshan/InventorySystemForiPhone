//
//  ISSettingViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSettingViewController.h"

@interface ISSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSArray* dataList;
@property (nonatomic,strong) UIView* footerView;
@end


static NSString* cellId = @"ISSettingTableViewCell";

@implementation ISSettingViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    [self.view setBackgroundColor:RGB(243, 244, 245)];
    [self.view addSubview:self.tableView];
    [self autolayoutSubView];
    
    self.dataList = @[@{@"title":@"关于我们",@"info":@"玲珑进销存"},
                      @{@"title":@"APP版本",@"info":@"Ver1.0"},
                      @{@"title":@"联系电话",@"info":@"18988882888"}];
    [self.tableView reloadData];
}

- (void)autolayoutSubView{
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - 

- (void)logOut:(UIButton*)sender{
    [[[UIAlertView alloc] initWithTitle:@"确定要退出吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [ISSettingManager sharedInstance].logined = NO;
        [ISSettingManager sharedInstance].currentUser = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell configureWithData:self.dataList[indexPath.row] indexPath:indexPath superView:tableView];
    return cell;
}


#pragma mark - property

- (UITableView*)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (UIView*)footerView{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        UIButton* logOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth - 15 * 2, 40)];
        [logOutBtn setTitle:@"退出" forState:UIControlStateNormal];
        [logOutBtn setBackgroundColor:TheameColorAlpha(1)];
        [logOutBtn addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
        logOutBtn.layer.cornerRadius = 4.0;
        logOutBtn.clipsToBounds = YES;
        [_footerView addSubview:logOutBtn];
    }
    return _footerView;
}

@end
