//
//  ISSaleOrderViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSaleOrderViewController.h"
#import "ISSearchFieldViewController.h"
#import "BCPhotoPickerViewController.h"
#import "ISAddProductViewController.h"

#import "ISParterDataModel.h"

#import "ISOrderHeaderView.h"
#import "ISOrderBottomView.h"

@interface ISSaleOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ISOrderHeaderView * orderHeaderView;
@property (nonatomic, strong) ISOrderBottomView * orderBottomView;
@property (nonatomic, strong) UITableView * saleOrderTableView;
@property (nonatomic, strong) NSMutableArray * dataList;
@property (nonatomic, strong) ISOrderViewModel * orderViewModel;
@property (nonatomic, strong) ISParterDataModel * partnerModel;
@end


static NSString* orderCell = @"ISOrderTableViewCell";
static NSString* spaceCell = @"ISSpaceTableViewCell";
static NSString* imageCell = @"ISOrderPhotoTableViewCell";

static float bottomHeight = 49;

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
    [self.view addSubview:self.orderBottomView];
    [self autolayoutSubView];
    [self setupData];
}

- (void)setupData{
    self.dataList = [NSMutableArray array];
    [self.dataList addObject:@{@"type":spaceCell,@"data":@{@"height":@(10),@"bgColor":RGB(239, 244, 244)}}];
    [self.dataList addObject:@{@"type":orderCell,@"data":@""}];
    self.orderHeaderView.orderNOLabel.text = [self.orderViewModel generateSaleOrderNo];
    
    [self.saleOrderTableView reloadData];
}

- (void)autolayoutSubView{
    
    self.orderHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.orderHeaderView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.saleOrderTableView];
    [self.orderHeaderView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.saleOrderTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, bottomHeight, 0)];
    
    [self.orderBottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [self.orderBottomView autoSetDimension:ALDimensionHeight toSize:bottomHeight];

}

#pragma mark - event

- (void)showSearch:(id)sender{
    
    __weak typeof(self) weakSelf = self;
    ISSearchFieldViewController * searchController = [[ISSearchFieldViewController alloc] initWithType:ISSearchFieldTypeCustomer finish:^(ISParterDataModel * model) {
        [weakSelf.orderHeaderView.customerBtn setTitle:model.PartnerName forState:UIControlStateNormal];
        weakSelf.orderHeaderView.customerBtn.selected = NO;
        weakSelf.partnerModel = model;
    }];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}


- (void)postOrder:(id)sender{
    
}

- (void)takePhoto:(UIButton*)sender{
    
    BCPhotoPickerViewController * photoPickerController = [[BCPhotoPickerViewController alloc] init];
    photoPickerController.maxOfSelection = 1;
    __weak typeof(self) weakSelf = self;
    photoPickerController.block = ^(NSArray * data){
        if ( sender == weakSelf.orderBottomView.takeInDoorPhotoBtn) {
            NSDictionary * imageDic = [weakSelf getImageCell];
            [imageDic setValue:[data firstObject] forKeyPath:@"data.in"];
        }else{
            NSDictionary * imageDic = [weakSelf getImageCell];
            [imageDic setValue:[data firstObject] forKeyPath:@"data.out"];
        }
        [weakSelf.saleOrderTableView reloadData];
    };
    [self presentViewController:photoPickerController animated:YES completion:nil];
}

- (void)addProduct:(UIButton*)sender{
    
    if (!self.partnerModel) {
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"请先选择客户" InView:self.view];
        return;
    }
    
    ISAddProductViewController * addProductController = [[ISAddProductViewController alloc] initWithType:ISAddProductTypeNew block:^(id object) {
        
    }];
    addProductController.partnerModel = self.partnerModel;
    [self.navigationController pushViewController:addProductController animated:YES];
}

- (NSDictionary*)getImageCell{
    
    for(int i = 0; i < self.dataList.count; i++){
        NSDictionary * d = self.dataList[i];
        if ([d[@"type"] isEqualToString:imageCell]) {
            return d;
        }
    }
    NSDictionary * imageDic = @{@"type":imageCell,@"data":[@{@"in":[NSNull null],@"out":[NSNull null]} mutableCopy]};
    [self.dataList insertObject:imageDic atIndex:0];
    
    return imageDic;
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
        [_saleOrderTableView registerNib:[UINib nibWithNibName:imageCell bundle:nil] forCellReuseIdentifier:imageCell];

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
        _orderHeaderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ISOrderHeaderView class]) owner:nil options:nil] lastObject];
        [_orderHeaderView.customerBtn addTarget:self action:@selector(showSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderHeaderView;
}

- (ISOrderBottomView*)orderBottomView{
    if (_orderBottomView == nil) {
        _orderBottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ISOrderBottomView class]) owner:nil options:nil] lastObject];
        [_orderBottomView.takeInDoorPhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_orderBottomView.takeOutDoorPhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_orderBottomView.addProductBtn addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderBottomView;
}

- (ISOrderViewModel*)orderViewModel{
    if (_orderViewModel == nil) {
        _orderViewModel = [[ISOrderViewModel alloc] init];
    }
    return _orderViewModel;
}

@end
