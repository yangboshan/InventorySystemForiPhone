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
#import "ISOrderDataModel.h"
#import "ISOrderDetailModel.h"
#import "ISProductDataModel.h"

#import "ISOrderHeaderView.h"
#import "ISOrderBottomView.h"
#import "ISOrderSummaryView.h"

@interface ISSaleOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ISOrderHeaderView * orderHeaderView;
@property (nonatomic, strong) ISOrderBottomView * orderBottomView;
@property (nonatomic, strong) ISOrderSummaryView * orderSummaryView;
@property (nonatomic, strong) UITableView * saleOrderTableView;
@property (nonatomic, strong) NSMutableDictionary *offscreenCells;
@property (nonatomic, strong) NSMutableArray * dataList;
@property (nonatomic, strong) NSMutableArray * imageList;

@property (nonatomic, strong) ISOrderDataModel * orderDataModel;
@property (nonatomic, strong) ISParterDataModel * partnerModel;
@property (nonatomic, strong) ISOrderViewModel * orderViewModel;
@end


static NSString* orderCell = @"ISOrderTableViewCell";
static NSString* spaceCell = @"ISSpaceTableViewCell";
static NSString* addImageCell = @"ISOrderAddImageCell";


static float bottomHeight = 49;
static float summaryHeight = 35;

@implementation ISSaleOrderViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    UIBarButtonItem * saveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"上传单据" style:UIBarButtonItemStyleDone target:self action:@selector(postOrder:)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    
    [self.view setBackgroundColor:RGB(240, 240, 240)];
    [self.view addSubview:self.saleOrderTableView];
    [self.view addSubview:self.orderBottomView];
    [self.view addSubview:self.orderSummaryView];
    [self autolayoutSubView];
    [self setupData];
}

- (void)setupData{
    
    self.dataList = [NSMutableArray array];
    self.imageList = [NSMutableArray array];
    
    [self.dataList addObject:[@{@"type":spaceCell,@"data":@{@"height":@(5),@"bgColor":RGB(240, 240, 240)}} mutableCopy]];
    [self.dataList addObject:[@{@"type":addImageCell,@"data":self.imageList} mutableCopy]];

    self.orderDataModel.SwapCode = [self.orderViewModel generateSaleOrderNo];
    self.orderHeaderView.orderNOLabel.text = self.orderDataModel.SwapCode;
    
    [self updateBottomBar];
}

- (void)autolayoutSubView{
    
    [self.orderHeaderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.orderHeaderView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.saleOrderTableView];
    [self.orderHeaderView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.saleOrderTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, bottomHeight + summaryHeight, 0)];
    
    [self.orderBottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [self.orderBottomView autoSetDimension:ALDimensionHeight toSize:bottomHeight];
    [self.orderSummaryView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, bottomHeight, 0) excludingEdge:ALEdgeTop];
    [self.orderSummaryView autoSetDimension:ALDimensionHeight toSize:summaryHeight];
}

#pragma mark - event

//弹出客户搜索界面
- (void)showSearch:(id)sender{
    __weak typeof(self) weakSelf = self;
    ISSearchFieldViewController * searchController = [[ISSearchFieldViewController alloc] initWithType:ISSearchFieldTypeCustomer finish:^(ISParterDataModel * model) {
        [weakSelf.orderHeaderView.customerBtn setTitle:model.PartnerName forState:UIControlStateNormal];
        weakSelf.orderHeaderView.customerBtn.selected = NO;
        weakSelf.partnerModel = model;
        weakSelf.orderDataModel.PartnerId = model.PartnerId;
    }];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

//上传单据
- (void)postOrder:(id)sender{
    
}

//显示添加商品界面
- (void)addProduct:(UIButton*)sender{
    
    if (!self.partnerModel) {
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"请先选择客户" InView:self.view];
        return;
    }
    __weak typeof(self) weakSelf = self;
    ISAddProductViewController * addProductController = [[ISAddProductViewController alloc] initWithType:ISAddProductTypeNew block:^(ISOrderDetailModel * detailModel) {
        [weakSelf addDetailModel:detailModel];
    }];
    addProductController.partnerModel = self.partnerModel;
    addProductController.smallUnit = self.orderSummaryView.checkBtn.selected;
    [self.navigationController pushViewController:addProductController animated:YES];
}

- (void)addDetailModel:(ISOrderDetailModel*)detailModel{
    
    detailModel.SwapCode = self.orderDataModel.SwapCode;

    [[ISDataBaseHelper sharedInstance] updateDataBaseByModelList:@[self.orderDataModel] block:nil];
    [[ISDataBaseHelper sharedInstance] updateDataBaseByModelList:@[detailModel] block:nil];
    [self.dataList addObject:@{@"type":spaceCell,@"data":@{@"height":@(5),@"bgColor":RGB(240, 240, 240)}}];
    [self.dataList addObject:@{@"type":orderCell,@"data":detailModel}];
    [self.saleOrderTableView reloadData];
    [self updateBottomBar];
}


//更新底部总价
- (void)updateBottomBar{
    float summary = 0;
    for(int i = 0; i < self.dataList.count; i++){
        NSDictionary * d = self.dataList[i];
        if ([d[@"type"] isEqualToString:orderCell]) {
            ISOrderDetailModel * detailModel = d[@"data"];
            summary += [detailModel.Amt floatValue] * [detailModel.ProQuantity floatValue];
        }
    }
    self.orderSummaryView.summaryLabel.text = [NSString stringWithFormat:@"总计: %.2f",summary];
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

#pragma mark - property

- (UITableView*)saleOrderTableView{
    
    if (_saleOrderTableView == nil) {
        _saleOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_saleOrderTableView registerNib:[UINib nibWithNibName:orderCell bundle:nil] forCellReuseIdentifier:orderCell];
        [_saleOrderTableView registerNib:[UINib nibWithNibName:spaceCell bundle:nil] forCellReuseIdentifier:spaceCell];
        [_saleOrderTableView registerNib:[UINib nibWithNibName:addImageCell bundle:nil] forCellReuseIdentifier:addImageCell];

        _saleOrderTableView.delegate = self;
        _saleOrderTableView.dataSource = self;
        _saleOrderTableView.tableHeaderView = self.orderHeaderView;
        _saleOrderTableView.separatorColor = [UIColor clearColor];
        _saleOrderTableView.backgroundColor = RGB(240, 240, 240);
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
        [_orderBottomView.addProductBtn addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderBottomView;
}

- (ISOrderSummaryView*)orderSummaryView{
    if (_orderSummaryView == nil) {
        _orderSummaryView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ISOrderSummaryView class]) owner:nil options:nil] lastObject];
    }
    return _orderSummaryView;
}

- (ISOrderViewModel*)orderViewModel{
    if (_orderViewModel == nil) {
        _orderViewModel = [[ISOrderViewModel alloc] init];
    }
    return _orderViewModel;
}

- (ISOrderDataModel*)orderDataModel{
    if (_orderDataModel == nil) {
        _orderDataModel = [ISOrderDataModel new];
    }
    return _orderDataModel;
}

- (NSMutableDictionary*)offscreenCells{
    if (!_offscreenCells) {
        _offscreenCells = [NSMutableDictionary dictionary];
    }
    return _offscreenCells;
}

@end
