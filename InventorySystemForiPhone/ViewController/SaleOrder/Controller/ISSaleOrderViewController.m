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
#import "ISScanViewController.h"

#import "ISParterDataModel.h"
#import "ISOrderDataModel.h"
#import "ISOrderDetailModel.h"
#import "ISProductDataModel.h"
#import "ISMainPageViewModel.h"

#import "ISOrderHeaderView.h"
#import "ISOrderBottomView.h"
#import "ISOrderSummaryView.h"


#import "ISOrderInfoFormatter.h"
#import "ISNetworkingUploadOrderAPIHandler.h"
#import "ISNetworkingUploadReturnOrderAPIHandler.h"
#import "ISNetworkingUploadOrderPicAPIHandler.h"

@interface ISSaleOrderViewController ()<UITableViewDataSource,UITableViewDelegate,ISNetworkingAPIHandlerCallBackDelegate,ISNetworkingAPIHandlerParamSourceDelegate>
@property (nonatomic, strong) ISOrderHeaderView * orderHeaderView;
@property (nonatomic, strong) ISOrderBottomView * orderBottomView;
@property (nonatomic, strong) ISOrderSummaryView * orderSummaryView;
@property (nonatomic, strong) UITableView * saleOrderTableView;
@property (nonatomic, strong) NSMutableDictionary * offscreenCells;
@property (nonatomic, strong) NSMutableArray * dataList;
@property (nonatomic, strong) NSMutableArray * imageList;
@property (nonatomic, assign) ISOrderType type;

@property (nonatomic, strong) ISParterDataModel * partnerModel;
@property (nonatomic, strong) ISOrderViewModel * orderViewModel;
@property (nonatomic, strong) ISMainPageViewModel * mainPageViewModel;

@property (nonatomic, strong) ISOrderInfoFormatter * orderInfoFormatter;
@property (nonatomic, strong) ISNetworkingUploadOrderAPIHandler * uploadOrderAPIHandler;
@property (nonatomic, strong) ISNetworkingUploadReturnOrderAPIHandler * uploadReturnOrderAPIHandler;
@property (nonatomic, strong) ISNetworkingUploadOrderPicAPIHandler * uploadOrderPicAPIHandler;
@end


static NSString* orderCell = @"ISOrderTableViewCell";
static NSString* spaceCell = @"ISSpaceTableViewCell";
static NSString* addImageCell = @"ISOrderAddImageCell";


static float bottomHeight = 49;
static float summaryHeight = 35;

@implementation ISSaleOrderViewController

#pragma mark - lifeCycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kISOrderDeleteNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOrder:) name:kISOrderDeleteNotification object:nil];
    
    UIBarButtonItem * saveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"上传单据" style:UIBarButtonItemStyleDone target:self action:@selector(postOrder:)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    
    if (self.isFromQuery) {
        if ([self.orderDataModel.Status isEqualToString:@"1"]) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }

    
    switch (self.type) {
        case ISOrderTypeNormal:
            self.title = @"销售单据";
            break;
        case ISOrderTypeReturn:
            self.title = @"退货单据";
            break;
        default:
            break;
    }
    
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
    

    if (!self.isFromQuery) {
        self.orderDataModel.SwapCode = [self.orderViewModel generateSaleOrderNoByType:self.type];
    }else{
        
        ISParterDataModel * partnerModel = [self.orderViewModel fetchPartnerById:self.orderDataModel.PartnerId];
        [self.orderHeaderView.customerBtn setTitle:partnerModel.PartnerName forState:UIControlStateNormal];
        self.orderHeaderView.customerBtn.selected = NO;
        self.partnerModel = partnerModel;
        
        NSArray * detailList = [self.orderViewModel fetchOrderDetailListByOrderNo:self.orderDataModel.SwapCode];
        for(int i = 0; i < detailList.count; i++){
            ISOrderDetailModel * detailModel = detailList[i];
            [self.dataList addObject:@{@"type":spaceCell,@"data":@{@"height":@(5),@"bgColor":RGB(240, 240, 240)}}];
            [self.dataList addObject:@{@"type":orderCell,@"data":detailModel}];
        }
        [self.saleOrderTableView reloadData];
    }
    self.orderHeaderView.orderNOLabel.text = self.orderDataModel.SwapCode;
    [self.saleOrderTableView reloadData];
    [self updateBottomBar];
    
    if ([self.mainPageViewModel shouldLocation]) {
        [[ISLocationManager sharedInstance] startUpdatingLocation];
    }
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

#pragma mark - Notification

/**
 *  删除条目 更新本地数据酷 刷新列表
 *
 *  @param notify
 */
- (void)deleteOrder:(NSNotification*)notify{
    
    if (self.isFromQuery) {
        if ([self.orderDataModel.Status isEqualToString:@"1"]) {
            return;
        }
    }
    
    ISOrderDetailModel * model = notify.userInfo[@"model"];
    int index = 0;
    for(int i = 0;i < self.dataList.count; i++){
        NSDictionary * d = self.dataList[i];
        if ([d[@"type"] isEqualToString:orderCell]) {
            ISOrderDetailModel * detailModel = d[@"data"];
            if ([detailModel.DtlId isEqualToString:model.DtlId]) {
                index = i;
                break;
            }
        }
    }
    [self.dataList removeObjectAtIndex:index];
    [self.dataList removeObjectAtIndex:--index];
    [[ISDataBaseHelper sharedInstance] deleteDataBaseByModelList:@[model] block:nil];
    [self.saleOrderTableView reloadData];
    [self updateBottomBar];
}

#pragma mark - ISNetworkingAPIHandlerCallBackDelegate

- (void)orderUploadSuccess:(NSString*)result{
    if ([self.orderViewModel checkOrderNoWithNo:result type:self.type]) {
        [self.orderViewModel updateOrderWithNewNo:result oldNo:self.orderDataModel.SwapCode];
        self.orderDataModel.SwapCode = result;
        if (self.imageList.count) {
            [self.uploadOrderPicAPIHandler loadData];
        }else{
            [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"操作成功" InView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kISOrderDataRefreshNotification object:nil];
         });
    }else{
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:result InView:self.view];
    }
}

- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager{
    
    if ([manager isKindOfClass:[ISNetworkingUploadOrderAPIHandler class]]) {
        NSDictionary * data = [self.orderInfoFormatter manager:manager reformData:manager.fetchedRawData];
        if (![data[kISOderInfoResut] IS_isEmptyObject]) {
            [self orderUploadSuccess:data[kISOderInfoResut]];
        }
    }
    
    if ([manager isKindOfClass:[ISNetworkingUploadReturnOrderAPIHandler class]]) {
        NSDictionary * data = [self.orderInfoFormatter manager:manager reformData:manager.fetchedRawData];
        if (![data[kISOderInfoResut] IS_isEmptyObject]) {
            [self orderUploadSuccess:data[kISOderInfoResut]];
        }
    }
    
    if ([manager isKindOfClass:[ISNetworkingUploadOrderPicAPIHandler class]]) {
        NSDictionary * data = [self.orderInfoFormatter manager:manager reformData:manager.fetchedRawData];
        if (![data[kISOderInfoResut] IS_isEmptyObject]) {
            if ([data[kISOderInfoResut] isEqualToString:@"1"]) {
                if (self.imageList.count) {
                    [self.imageList removeObjectAtIndex:0];
                }
                if (self.imageList.count) {
                    [self.uploadOrderPicAPIHandler loadData];
                }else{
                    [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"操作成功" InView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"上传图片失败" InView:self.view];
            }
        }
    }
}

- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingUploadOrderAPIHandler class]]) {
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"上传订单数据失败" InView:self.view];
    }
    if ([manager isKindOfClass:[ISNetworkingUploadOrderPicAPIHandler class]]) {
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"上传图片失败" InView:self.view];
    }
}

#pragma mark - ISNetworkingAPIHandlerParamSourceDelegate

- (NSDictionary*)paramsForApi:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingUploadOrderAPIHandler class]]) {
        self.orderDataModel.Remark = [[self.orderSummaryView.remarkTextField.text trim] IS_isEmptyObject] ? @"" : [self.orderSummaryView.remarkTextField.text trim];
        return @{@"sPartnerId":self.orderDataModel.PartnerId,
                 @"sRemark":self.orderDataModel.Remark,
                 @"Cre_User":self.orderDataModel.UPD_USER,
                 @"SalesId":self.orderDataModel.CRE_USER,
                 @"picBF":@"",
                 @"picAF":@"",
                 @"upPosition":[ISLocationManager sharedInstance].fetchedLocation,
                 @"dsGrid":[self.orderViewModel generateParametersForOrderByList:[self.dataList valueForKey:@"data"]]};
    }
    if ([manager isKindOfClass:[ISNetworkingUploadReturnOrderAPIHandler class]]) {
        self.orderDataModel.Remark = [[self.orderSummaryView.remarkTextField.text trim] IS_isEmptyObject] ? @"" : [self.orderSummaryView.remarkTextField.text trim];
        return @{@"sPartnerId":self.orderDataModel.PartnerId,
                 @"sRemark":self.orderDataModel.Remark,
                 @"Cre_User":self.orderDataModel.UPD_USER,
                 @"SalesId":self.orderDataModel.CRE_USER,
                 @"dsGrid":[self.orderViewModel generateParametersForOrderByList:[self.dataList valueForKey:@"data"]]};
    }
    if ([manager isKindOfClass:[ISNetworkingUploadOrderPicAPIHandler class]]) {
        return @{@"SwapCode":self.orderDataModel.SwapCode,
                 @"Pic":[[[self.imageList firstObject][@"image"] compressedData] base64Encoding],
                 @"sRemark":[self.imageList firstObject][@"remark"]};
    }
    return nil;
}

#pragma mark - event

/**
 *  显示客户搜索界面
 *
 *  @param sender
 */
- (void)showSearch:(id)sender{
    __weak typeof(self) weakSelf = self;
    ISSearchFieldViewController * searchController = [[ISSearchFieldViewController alloc] initWithType:ISSearchFieldTypeCustomer finish:^(ISParterDataModel * model) {
        [weakSelf.orderHeaderView.customerBtn setTitle:model.PartnerName forState:UIControlStateNormal];
        weakSelf.orderHeaderView.customerBtn.selected = NO;
        weakSelf.partnerModel = model;
        weakSelf.orderDataModel.PartnerId = model.PartnerId;
        weakSelf.orderDataModel.PartnerName = model.PartnerName;
    }];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

/**
 *  上传单据
 *
 *  @param sender
 */
- (void)postOrder:(id)sender{
    
    if ([self.orderDataModel.PartnerId IS_isEmptyObject] || ![[self.dataList valueForKey:@"type"] containsObject:orderCell]) {
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"单据不完整" InView:self.view];
        return;
    }
    
    if ([self.mainPageViewModel shouldShootPhoto]) {
        if (!self.imageList.count) {
            [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"请选择图片并上传" InView:self.view];
            return;
        }
    }
    
    [[ISProcessViewHelper sharedInstance] showProcessViewInView:self.view];
    if (![self.orderViewModel checkOrderNoWithNo:self.orderDataModel.SwapCode type:self.type]) {
        switch (self.type) {
            case ISOrderTypeNormal:
                [self.uploadOrderAPIHandler loadData];
                  break;
            case ISOrderTypeReturn:
                [self.uploadReturnOrderAPIHandler loadData];
                break;
            default:
                break;
        }
    }else{
        [self.uploadOrderPicAPIHandler loadData];
    }
}

/**
 *  显示添加商品界面
 *
 *  @param sender
 */
- (void)addProduct:(UIButton*)sender{
    
    if (self.isFromQuery) {
        if ([self.orderDataModel.Status isEqualToString:@"1"]) {
            return;
        }
    }
    
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


/**
 *  扫描条码
 *
 *  @param sender
 */
- (void)scan:(id)sender{
    
    if (self.isFromQuery) {
        if ([self.orderDataModel.Status isEqualToString:@"1"]) {
            return;
        }
    }
    
    if (!self.partnerModel) {
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"请先选择客户" InView:self.view];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    ISScanViewController * scanController = [ISScanViewController new];
    scanController.block = ^(NSString * result){
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (![result IS_isEmptyObject]) {
            ISAddProductViewController * addProductController = [[ISAddProductViewController alloc] initWithType:ISAddProductTypeScan block:^(ISOrderDetailModel * detailModel) {
                [weakSelf addDetailModel:detailModel];
            }];
            ISProductDataModel * product = [weakSelf.orderViewModel fetchProductByBarCode:result];
            if (product) {
                addProductController.productId = product.ProId;
                addProductController.partnerModel = weakSelf.partnerModel;
                addProductController.smallUnit = weakSelf.orderSummaryView.checkBtn.selected;
                [weakSelf.navigationController pushViewController:addProductController animated:YES];
            }else{
                [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"产品不存在" InView:weakSelf.view];
            }
        }
    };
    [self.navigationController pushViewController:scanController animated:NO];
}

/**
 *  添加商品成功后 更新DetailModel订单号 ID 刷新列表
 *
 *  @param detailModel
 */
- (void)addDetailModel:(ISOrderDetailModel*)detailModel{

    detailModel.SwapCode = self.orderDataModel.SwapCode;
    detailModel.DtlId = [self.orderViewModel generateDetailIdWithOrderNo:detailModel.SwapCode];


    [self.dataList addObject:@{@"type":spaceCell,@"data":@{@"height":@(5),@"bgColor":RGB(240, 240, 240)}}];
    [self.dataList addObject:@{@"type":orderCell,@"data":detailModel}];
    [self.saleOrderTableView reloadData];
    
    [self updateBottomBar];
    [[ISDataBaseHelper sharedInstance] updateDataBaseByModelList:@[self.orderDataModel] block:nil];
    [[ISDataBaseHelper sharedInstance] updateDataBaseByModelList:@[detailModel] block:nil];
}



/**
 *  更新底部总价
 */
- (void)updateBottomBar{
    float summary = 0;
    for(int i = 0; i < self.dataList.count; i++){
        NSDictionary * d = self.dataList[i];
        if ([d[@"type"] isEqualToString:orderCell]) {
            ISOrderDetailModel * detailModel = d[@"data"];
            float price = [detailModel.Amt floatValue];
            float amount = [detailModel.ProQuantity floatValue];
            summary +=  price * amount;
        }
    }
    self.orderDataModel.sumAmt = [NSString stringWithFormat:@"%.2f",summary];
    self.orderSummaryView.summaryLabel.text = [NSString stringWithFormat:@"总计: %.2f",summary];
}

- (void)textFieldDidEndEditing:(id)sender{
    self.orderDataModel.Remark = self.orderSummaryView.remarkTextField.text;
    if ([[self.dataList valueForKey:@"type"] containsObject:orderCell]) {
        [[ISDataBaseHelper sharedInstance] updateDataBaseByModelList:@[self.orderDataModel] block:nil];
    }
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
        [_orderBottomView.scanBtn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderBottomView;
}

- (ISOrderSummaryView*)orderSummaryView{
    if (_orderSummaryView == nil) {
        _orderSummaryView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ISOrderSummaryView class]) owner:nil options:nil] lastObject];
        [_orderSummaryView.remarkTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _orderSummaryView;
}

- (ISOrderViewModel*)orderViewModel{
    if (_orderViewModel == nil) {
        _orderViewModel = [[ISOrderViewModel alloc] init];
    }
    return _orderViewModel;
}

- (ISMainPageViewModel*)mainPageViewModel{
    if (_mainPageViewModel == nil) {
        _mainPageViewModel = [[ISMainPageViewModel alloc] init];
    }
    return _mainPageViewModel;
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

- (ISNetworkingBaseAPIHandler*)uploadOrderPicAPIHandler{
    if (_uploadOrderPicAPIHandler == nil) {
        _uploadOrderPicAPIHandler = [ISNetworkingUploadOrderPicAPIHandler new];
        _uploadOrderPicAPIHandler.delegate = self;
        _uploadOrderPicAPIHandler.paramSource = self;
    }
    return _uploadOrderPicAPIHandler;
}

- (ISNetworkingUploadOrderAPIHandler*)uploadOrderAPIHandler{
    if (_uploadOrderAPIHandler == nil) {
        _uploadOrderAPIHandler = [ISNetworkingUploadOrderAPIHandler new];
        _uploadOrderAPIHandler.delegate = self;
        _uploadOrderAPIHandler.paramSource = self;
    }
    return _uploadOrderAPIHandler;
}

- (ISNetworkingUploadReturnOrderAPIHandler*)uploadReturnOrderAPIHandler{
    if (_uploadReturnOrderAPIHandler == nil) {
        _uploadReturnOrderAPIHandler = [ISNetworkingUploadReturnOrderAPIHandler new];
        _uploadReturnOrderAPIHandler.delegate = self;
        _uploadReturnOrderAPIHandler.paramSource = self;
    }
    return _uploadReturnOrderAPIHandler;
}

- (ISOrderInfoFormatter*)orderInfoFormatter{
    if (_orderInfoFormatter == nil) {
        _orderInfoFormatter = [ISOrderInfoFormatter new];
    }
    return _orderInfoFormatter;
}

@end
