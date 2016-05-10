//
//  ISSaleOrderViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSaleOrderViewController.h"
#import "ISOrderHeaderView.h"
#import "ISSearchFieldViewController.h"

@interface ISSaleOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ISOrderHeaderView * orderHeaderView;
@property (nonatomic,strong) UITableView * saleOrderTableView;
@property (nonatomic,strong) NSMutableArray * dataList;
@end


static NSString* orderCell = @"ISOrderTableViewCell";
static NSString* spaceCell = @"ISSpaceTableViewCell";

@implementation ISSaleOrderViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    [self.view setBackgroundColor:RGB(239, 244, 244)];
    
    UIBarButtonItem * saveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"上传单据" style:UIBarButtonItemStyleDone target:self action:@selector(postOrder:)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    
    [self.view addSubview:self.saleOrderTableView];
    [self autolayoutSubView];
    [self setupData];
}

- (void)setupData{
    self.dataList = [NSMutableArray array];
    [self.dataList addObject:@{@"type":spaceCell,@"data":@{@"height":@(10),@"bgColor":RGB(239, 244, 244)}}];
    [self.dataList addObject:@{@"type":orderCell,@"data":@""}];
    [self.dataList addObject:@{@"type":spaceCell,@"data":@{@"height":@(5),@"bgColor":RGB(239, 244, 244)}}];
    [self.dataList addObject:@{@"type":orderCell,@"data":@""}];


    [self.saleOrderTableView reloadData];
}

- (void)autolayoutSubView{
    self.orderHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.orderHeaderView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.saleOrderTableView];
    [self.saleOrderTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.orderHeaderView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - event

- (void)showSearch:(id)sender{
    
    ISSearchFieldViewController * searchController = [[ISSearchFieldViewController alloc] initWithType:ISSearchFieldTypeCustomer finish:^(NSString *result) {
    }];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}


- (void)postOrder:(id)sender{
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* data = self.dataList[indexPath.row];
    NSString* cellType = data[@"type"];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellType];
    [cell configureWithData:data[@"data"] indexPath:indexPath superView:tableView];
    return cell;
    
}

#pragma mark - property

- (UITableView*)saleOrderTableView{
    
    if (_saleOrderTableView == nil) {
        _saleOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_saleOrderTableView registerNib:[UINib nibWithNibName:orderCell bundle:nil] forCellReuseIdentifier:orderCell];
        [_saleOrderTableView registerNib:[UINib nibWithNibName:spaceCell bundle:nil] forCellReuseIdentifier:spaceCell];
        
        _saleOrderTableView.delegate = self;
        _saleOrderTableView.dataSource = self;
        _saleOrderTableView.tableHeaderView = self.orderHeaderView;
        _saleOrderTableView.estimatedRowHeight = 50.0;
        _saleOrderTableView.rowHeight = UITableViewAutomaticDimension;
        _saleOrderTableView.separatorColor = [UIColor clearColor];
    }
    return _saleOrderTableView;
}


- (ISOrderHeaderView*)orderHeaderView{
    if (_orderHeaderView == nil) {
        _orderHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ISOrderHeaderView" owner:nil options:nil] lastObject];
        [_orderHeaderView.customerBtn addTarget:self action:@selector(showSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderHeaderView;
}


@end
