//
//  ISQueryOrderViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISQueryOrderViewController.h"
#import "ISSaleOrderViewController.h"
#import "ISQueryOrderHeaderView.h"
#import "ISSearchFieldViewController.h"

#import "ISParterDataModel.h"
#import "ISOrderViewModel.h"
#import "ISOrderDataModel.h"


@interface ISQueryOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ISQueryOrderHeaderView * orderHeaderView;
@property (nonatomic, strong) UITableView * saleOrderTableView;
@property (nonatomic, strong) NSMutableDictionary * offscreenCells;
@property (nonatomic, strong) NSMutableArray * dataList;
@property (nonatomic, strong) ISParterDataModel * partnerModel;
@property (nonatomic, strong) ISOrderViewModel * orderViewModel;
@end


static NSString* spaceCell = @"ISSpaceTableViewCell";
static NSString* orderCell = @"ISQueryOrderCell";

@implementation ISQueryOrderViewController

#pragma mark - lifeCycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kISOrderDataDeleteNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOrder:) name:kISOrderDataDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:kISOrderDataRefreshNotification object:nil];

    [self.view setBackgroundColor:RGB(243, 244, 245)];
    [self.view addSubview:self.saleOrderTableView];
    [self autolayoutSubView];
    self.dataList = [NSMutableArray array];
}

- (void)autolayoutSubView{
    [self.orderHeaderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.orderHeaderView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.saleOrderTableView];
    [self.orderHeaderView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.saleOrderTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - Notification

/**
 *  删除条目 更新本地数据酷 刷新列表
 *
 *  @param notify
 */
- (void)deleteOrder:(NSNotification*)notify{
    ISOrderDataModel * model = notify.userInfo[@"model"];
    int index = 0;
    for(int i = 0;i < self.dataList.count; i++){
        NSDictionary * d = self.dataList[i];
        if ([d[@"type"] isEqualToString:orderCell]) {
            ISOrderDataModel * orderModel = d[@"data"];
            if ([orderModel.SwapCode isEqualToString:model.SwapCode]) {
                index = i;
                break;
            }
        }
    }
    [self.dataList removeObjectAtIndex:index];
    [self.dataList removeObjectAtIndex:--index];
    [[ISDataBaseHelper sharedInstance] deleteDataBaseByModelList:@[model] block:nil];
    [self.saleOrderTableView reloadData];
}

#pragma mark - event

- (void)refreshList{
    
    [self.dataList removeAllObjects];
    NSArray * orderList =  [self.orderViewModel fetchOrderListByPartner:self.partnerModel date:self.orderHeaderView.dateLabel.text];
    for(int i = 0; i < orderList.count; i++){
        [self.dataList addObject:[@{@"type":spaceCell,@"data":@{@"height":@(5),@"bgColor":RGB(240, 240, 240)}} mutableCopy]];
        [self.dataList addObject:@{@"type":orderCell,@"data":orderList[i]}];
    }
    [self.saleOrderTableView reloadData];
}


- (void)showSearch:(id)sender{
    __weak typeof(self) weakSelf = self;
    ISSearchFieldViewController * searchController = [[ISSearchFieldViewController alloc] initWithType:ISSearchFieldTypeCustomer finish:^(ISParterDataModel * model) {
        [weakSelf.orderHeaderView.customBtn setTitle:model.PartnerName forState:UIControlStateNormal];
        weakSelf.orderHeaderView.customBtn.selected = NO;
        weakSelf.partnerModel = model;
        [weakSelf refreshList];
    }];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cellId = self.dataList[indexPath.row][@"type"];
    UITableViewCell* cell = self.offscreenCells[cellId];
    
    if (!self.offscreenCells[cellId]) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] lastObject];
        [self.offscreenCells setObject:cell forKey:cellId];
    }
    [cell configureWithData:self.dataList[indexPath.row][@"data"] indexPath:indexPath superView:tableView];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height+=1;
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellId = self.dataList[indexPath.row][@"type"];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell configureWithData:self.dataList[indexPath.row][@"data"] indexPath:indexPath superView:tableView];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellId = self.dataList[indexPath.row][@"type"];
    if ([cellId isEqualToString:orderCell]) {
        ISOrderDataModel * model = self.dataList[indexPath.row][@"data"];
        ISSaleOrderViewController * controller = [ISSaleOrderViewController new];
        controller.isFromQuery = YES;
        controller.orderDataModel = model;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - property

- (UITableView*)saleOrderTableView{
    
    if (_saleOrderTableView == nil) {
        _saleOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_saleOrderTableView registerNib:[UINib nibWithNibName:spaceCell bundle:nil] forCellReuseIdentifier:spaceCell];
        [_saleOrderTableView registerNib:[UINib nibWithNibName:orderCell bundle:nil] forCellReuseIdentifier:orderCell];

        _saleOrderTableView.delegate = self;
        _saleOrderTableView.dataSource = self;
        _saleOrderTableView.tableHeaderView = self.orderHeaderView;
        _saleOrderTableView.separatorColor = [UIColor clearColor];
        _saleOrderTableView.backgroundColor = RGB(240, 240, 240);
    }
    return _saleOrderTableView;
}

- (ISQueryOrderHeaderView*)orderHeaderView{
    if (_orderHeaderView == nil) {
        __weak typeof(self) weakSelf = self;
        _orderHeaderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ISQueryOrderHeaderView class]) owner:nil options:nil] lastObject];
        _orderHeaderView.block = ^ (id obj){
            [weakSelf refreshList];
        };
        [_orderHeaderView.customBtn addTarget:self action:@selector(showSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderHeaderView;
}

- (NSMutableDictionary*)offscreenCells{
    if (!_offscreenCells) {
        _offscreenCells = [NSMutableDictionary dictionary];
    }
    return _offscreenCells;
}

- (ISOrderViewModel*)orderViewModel{
    if (_orderViewModel == nil) {
        _orderViewModel = [[ISOrderViewModel alloc] init];
    }
    return _orderViewModel;
}

@end
