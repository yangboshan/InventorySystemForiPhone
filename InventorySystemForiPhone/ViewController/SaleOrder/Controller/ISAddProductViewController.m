//
//  ISAddProductViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/11.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISAddProductViewController.h"
#import "ISOrderDetailModel.h"
#import "ISOrderViewModel.h"
#import "ISParterDataModel.h"
#import "ISOrderInfoFormatter.h"

#import "ISNetworkingPriceAPIHandler.h"
#import "ISNetworkingStockAPIHandler.h"
#import "ISNetworkingLastInfoAPIHandler.h"

@interface ISAddProductViewController () <UITableViewDataSource,UITableViewDelegate,ISNetworkingAPIHandlerCallBackDelegate,ISNetworkingAPIHandlerParamSourceDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataList;

@property (nonatomic, strong) ISNetworkingPriceAPIHandler * priceAPIHandler;
@property (nonatomic, strong) ISNetworkingStockAPIHandler * stockAPIHandler;
@property (nonatomic, strong) ISNetworkingLastInfoAPIHandler * lastInfoAPIHandler;
@property (nonatomic, strong) ISOrderInfoFormatter * orderInfoFormatter;

@property (nonatomic, copy)   ISAddProductBlock block;
@property (nonatomic, assign) ISAddProductType type;
@property (nonatomic, strong) ISOrderViewModel * orderViewModel;
@property (nonatomic, strong) ISOrderDetailModel *orderDetailModel;
@property (nonatomic, strong) NSMutableDictionary * sourceFields;

@end


static NSString* infoCell = @"ISAddProductNameTableViewCell";


@implementation ISAddProductViewController

#pragma mark - life Cycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kISOrderRefreshNotification object:nil];
}

- (instancetype)initWithType:(ISAddProductType)type block:(ISAddProductBlock)block{
    if (self = [super init]) {
        self.block = block;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    [self.view setBackgroundColor:RGB(239, 244, 244)];
    [self.view addSubview:self.tableView];
    [self autolayoutSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderRefresh:) name:kISOrderRefreshNotification object:nil];
}

- (void)autolayoutSubView{
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - NSNotification

- (void)orderRefresh:(NSNotification*)notify{
    [[ISProcessViewHelper sharedInstance] showProcessViewInView:self.view];
    [self.priceAPIHandler loadData];
}


#pragma mark - ISNetworkingAPIHandlerCallBackDelegate

- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager{
    
    if ([manager isKindOfClass:[ISNetworkingPriceAPIHandler class]]) {
        NSDictionary * data = [self.orderInfoFormatter manager:manager reformData:manager.fetchedRawData];
        if (![data[kISOderInfoResut] IS_isEmptyObject]) {
            self.sourceFields[@"Amt"] = [NSString stringWithFormat:@"%.2f",[data[kISOderInfoResut] floatValue]];
            if (![self.sourceFields[@"ProQuantity"] IS_isEmptyObject]) {
                self.sourceFields[@"N_JinE"] = [NSString stringWithFormat:@"%.2f", [self.sourceFields[@"Amt"] floatValue] * [self.sourceFields[@"ProQuantity"] floatValue]];
                [self.tableView reloadData];
            }
        }
        [self.stockAPIHandler loadData];
    }
    
    if ([manager isKindOfClass:[ISNetworkingStockAPIHandler class]]) {
        NSDictionary * data = [self.orderInfoFormatter manager:manager reformData:manager.fetchedRawData];
        if (![data[kISOderInfoResut] IS_isEmptyObject]) {
            self.sourceFields[@"N_KuCun"] = data[kISOderInfoResut];
            [self.tableView reloadData];
        }
        [self.lastInfoAPIHandler loadData];
    }
    
    if ([manager isKindOfClass:[ISNetworkingLastInfoAPIHandler class]]) {
        NSDictionary * data = [self.orderInfoFormatter manager:manager reformData:manager.fetchedRawData];
        if (![data[kISOderInfoResut] IS_isEmptyObject]) {
            self.sourceFields[@"N_TiShi"] = data[kISOderInfoResut];
            [self.tableView reloadData];
        }
        [[ISProcessViewHelper sharedInstance] hideProcessViewInView:self.view];
    }
}

- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager{
    [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"ERROR" InView:self.view];
}

#pragma mark - ISNetworkingAPIHandlerParamSourceDelegate

- (NSDictionary*)paramsForApi:(ISNetworkingBaseAPIHandler *)manager{
    
    if ([manager isKindOfClass:[ISNetworkingPriceAPIHandler class]]) {
        return @{@"sProId":self.sourceFields[@"ProId"],@"sPartnerId":self.partnerModel.PartnerId,@"sUniteName":self.sourceFields[@"ProUnite"],@"sPartnerName":self.partnerModel.PartnerName};
    }
    if ([manager isKindOfClass:[ISNetworkingStockAPIHandler class]]) {
        return @{@"sProId":self.sourceFields[@"ProId"]};
    }
    if ([manager isKindOfClass:[ISNetworkingLastInfoAPIHandler class]]) {
        return @{@"sProId":self.sourceFields[@"ProId"],@"sPartnerId":self.partnerModel.PartnerId,@"sUniteName":self.sourceFields[@"ProUnite"]};
    }
    return nil;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:self.dataList[indexPath.row][@"type"]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell configureWithData:self.dataList[indexPath.row][@"data"] indexPath:indexPath superView:tableView];
}

#pragma mark - property

- (ISOrderInfoFormatter*)orderInfoFormatter{
    if (_orderInfoFormatter == nil) {
        _orderInfoFormatter = [ISOrderInfoFormatter new];
    }
    return _orderInfoFormatter;
}

- (ISNetworkingBaseAPIHandler*)priceAPIHandler{
    if (_priceAPIHandler == nil) {
        _priceAPIHandler = [ISNetworkingPriceAPIHandler new];
        _priceAPIHandler.delegate = self;
        _priceAPIHandler.paramSource = self;
    }
    return _priceAPIHandler;
}

- (ISNetworkingBaseAPIHandler*)lastInfoAPIHandler{
    if (_lastInfoAPIHandler == nil) {
        _lastInfoAPIHandler = [ISNetworkingLastInfoAPIHandler new];
        _lastInfoAPIHandler.delegate = self;
        _lastInfoAPIHandler.paramSource = self;
    }
    return _lastInfoAPIHandler;
}

- (ISNetworkingBaseAPIHandler*)stockAPIHandler{
    if (_stockAPIHandler == nil) {
        _stockAPIHandler = [ISNetworkingStockAPIHandler new];
        _stockAPIHandler.delegate = self;
        _stockAPIHandler.paramSource = self;
    }
    return _stockAPIHandler;
}

- (UITableView*)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        [_tableView setSeparatorColor:[UIColor clearColor]];
        [_tableView registerNib:[UINib nibWithNibName:infoCell bundle:nil] forCellReuseIdentifier:infoCell];
    }
    return _tableView;
}

- (NSMutableDictionary*)sourceFields{
    if (_sourceFields == nil) {
        _sourceFields = [NSMutableDictionary dictionary];
        NSArray * propertyList = [[ISDataBaseHelper sharedInstance] propertyListFromModel:self.orderDetailModel];
        for(int i = 0; i < [propertyList count]; i++ ){
            NSString * property = propertyList[i];
            if ([NSString stringIsNilOrEmpty:[self.orderDetailModel valueForKey:property]]) {
                [_sourceFields setValue:@"" forKey:propertyList[i]];
            }else{
                [_sourceFields setValue:[self.orderDetailModel valueForKey:property] forKey:propertyList[i]];
            }
        }
        [_sourceFields setValue:@"" forKey:@"N_MingCheng"];
        [_sourceFields setValue:@"" forKey:@"N_JinE"];
        [_sourceFields setValue:@"" forKey:@"N_GuiGe"];
        [_sourceFields setValue:@"" forKey:@"N_KuCun"];
        [_sourceFields setValue:@"" forKey:@"N_TiShi"];
    }
    return _sourceFields;
}

- (ISOrderDetailModel*)orderDetailModel{
    if (_orderDetailModel == nil) {
        switch (self.type) {
            case ISAddProductTypeNew:
                _orderDetailModel = [ISOrderDetailModel new];
                _orderDetailModel.ProQuantity = @"1";
                break;
            case ISAddProductTypeScan:
                _orderDetailModel = [ISOrderDetailModel new];
                _orderDetailModel.ProQuantity = @"1";
                _orderDetailModel.ProId = self.productId;
                break;
            default:
                break;
        }
    }
    return _orderDetailModel;
}

- (NSArray*)dataList{
    if (_dataList == nil) {
        _dataList = @[@{@"type":infoCell,@"data":@{@"info":@"名称:",@"model":self.sourceFields,@"field":@"N_MingCheng"}},
                      @{@"type":infoCell,@"data":@{@"info":@"单位:",@"model":self.sourceFields,@"field":@"ProUnite"}},
                      @{@"type":infoCell,@"data":@{@"info":@"数量:",@"model":self.sourceFields,@"field":@"ProQuantity"}},
                      @{@"type":infoCell,@"data":@{@"info":@"单价:",@"model":self.sourceFields,@"field":@"Amt"}},
                      @{@"type":infoCell,@"data":@{@"info":@"金额:",@"model":self.sourceFields,@"field":@"N_JinE"}},
                      @{@"type":infoCell,@"data":@{@"info":@"规格:",@"model":self.sourceFields,@"field":@"N_GuiGe"}},
                      @{@"type":infoCell,@"data":@{@"info":@"库存:",@"model":self.sourceFields,@"field":@"N_KuCun"}},
                      @{@"type":infoCell,@"data":@{@"info":@"提示:",@"model":self.sourceFields,@"field":@"N_TiShi"}},
                      @{@"type":infoCell,@"data":@{@"info":@"特价:",@"model":self.sourceFields,@"field":@"tejia"}},
                      @{@"type":infoCell,@"data":@{@"info":@"数量(赠):",@"model":self.sourceFields,@"field":@"LargessQty"}},
                      @{@"type":infoCell,@"data":@{@"info":@"单位(赠):",@"model":self.sourceFields,@"field":@"LargessUnite"}},
                      @{@"type":infoCell,@"data":@{@"info":@"备注:",@"model":self.sourceFields,@"field":@"Remark"}}];
    }
    return _dataList;
}

@end
