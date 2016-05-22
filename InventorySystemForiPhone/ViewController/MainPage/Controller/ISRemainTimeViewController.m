//
//  ISRemainTimeViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISRemainTimeViewController.h"
#import "ISNetworkingRegisterInfoAPIHandler.h"
#import "ISRemainTimeFormatter.h"
#import "ISWebViewController.h"

@interface ISRemainTimeViewController ()<ISNetworkingAPIHandlerCallBackDelegate,ISNetworkingAPIHandlerParamSourceDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ISNetworkingRegisterInfoAPIHandler* registerInfoAPIHandler;
@property (nonatomic,strong) ISRemainTimeFormatter * remainTimeFormatter;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSArray* dataList;
@property (nonatomic,strong) UIView* footerView;
@end

static NSString* cellId = @"cellId";
static NSString* chargeUrl = @"http://www.linoon.com/MPay/PaySelect.aspx?hashID=";

@implementation ISRemainTimeViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    if (!self.noTimeLeft) {
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMain:)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    [self.view setBackgroundColor:RGB(243, 244, 245)];
    [self.view addSubview:self.tableView];
    [self autolayoutSubView];
}

- (void)autolayoutSubView{
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[ISProcessViewHelper sharedInstance] showProcessViewInView:self.view];
    [self.registerInfoAPIHandler loadData];
}

#pragma mark - events

- (void)backMain:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chargeAccount:(UIButton*)sender{
    ISWebViewController* webController = [ISWebViewController new];
    webController.url = [NSString stringWithFormat:@"%@%@",chargeUrl,[[ISSettingManager sharedInstance].deviceId uppercaseString]];
    webController.resTitle = @"充值";
    [self.navigationController pushViewController:webController animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSDictionary* d = self.dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",[d.allKeys firstObject],[d.allValues firstObject]];
    cell.textLabel.font = Lantinghei(14);
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}


#pragma mark - ISNetworkingAPIHandlerCallBackDelegate

- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingRegisterInfoAPIHandler class]]) {
        NSDictionary* data = [self.remainTimeFormatter manager:manager reformData:manager.fetchedRawData];
        NSDate * date =  [NSDate dateFromString:data[kISRemainTimeLastLoginDate] withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
        self.dataList = @[@{@"设备编号:":[data[kISRemainTimeDeviceId] uppercaseString]},
                          @{@"使用公司:":data[kISRemainTimeUser]},
                          @{@"过期日期:":[NSString stringWithFormat:@"%@天",data[kISRemainTimeExpirationDay]]},
                          @{@"上次登录:":[date dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"]}];
        [self.tableView reloadData];
        [[ISProcessViewHelper sharedInstance] hideProcessViewInView:self.view];
    }
}

- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager{
    [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"ERROR" InView:self.view];
}

#pragma mark - ISNetworkingAPIHandlerParamSourceDelegate

- (NSDictionary*)paramsForApi:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingRegisterInfoAPIHandler class]]) {
        return @{@"HashID":[[ISSettingManager sharedInstance].deviceId uppercaseString]};
    }
    return nil;
}

#pragma mark - property

- (ISNetworkingRegisterInfoAPIHandler*)registerInfoAPIHandler{
    if (_registerInfoAPIHandler == nil) {
        _registerInfoAPIHandler = [[ISNetworkingRegisterInfoAPIHandler alloc] init];
        _registerInfoAPIHandler.paramSource = self;
        _registerInfoAPIHandler.delegate = self;
    }
    return _registerInfoAPIHandler;
}

- (ISRemainTimeFormatter*)remainTimeFormatter{
    if (!_remainTimeFormatter) {
        _remainTimeFormatter = [ISRemainTimeFormatter new];
    }
    return _remainTimeFormatter;
}

- (UITableView*)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (UIView*)footerView{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        UIButton* chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth - 15 * 2, 40)];
        [chargeBtn setTitle:@"去充值" forState:UIControlStateNormal];
        [chargeBtn setBackgroundColor:TheameColor];
        [chargeBtn addTarget:self action:@selector(chargeAccount:) forControlEvents:UIControlEventTouchUpInside];
        chargeBtn.layer.cornerRadius = 4.0;
        chargeBtn.clipsToBounds = YES;
        [_footerView addSubview:chargeBtn];
    }
    return _footerView;
}

@end
