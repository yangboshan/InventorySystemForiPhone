//
//  ISOrderViewModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderViewModel.h"
#import "ISProductDataModel.h"
#import "ISParterDataModel.h"
#import "ISOrderDetailModel.h"
#import "ISOrderDataModel.h"


@interface ISOrderViewModel()

@end

//客户列表
static NSString* IS_SQL_getCustomerList = @"select * from t_PartnerData where (pycode like '%%%@%%' or partnercode like '%%%@%%' or PartnerName like '%%%@%%') and type like '客户%%' and DelFlag='false' and Disconnect = 'false'";

//产品列表
static NSString* IS_SQL_getProductList = @"select * from t_ProductData where pycode like '%%%@%%' or procode like '%%%@%%' or ProName like '%%%@%%'";

//订单号
static NSString* IS_SQL_getMaxOrderNo = @"select substr(ifnull(max(SwapCode),'T197001010000'),10,4)  from t_SwapBillList where SwapCode like '%@%%'";

static NSString* IS_SQL_getMaxReturnOrderNo = @"select substr(ifnull(max(SwapCode),'R197001010000'),10,4)  from t_SwapBillList where SwapCode like '%@%%'";

//根据ID获取产品
static NSString* IS_SQL_getProductById = @"select * from t_ProductData where proid = '%@'";

//根据产品获取单位
static NSString* IS_SQL_getUnitByProductId = @"select UniteName from t_unite where proid = '%@' order by Uniterate";

//根据产品和单位获取本地价格
static NSString* IS_SQL_getLocalPrice = @"select ifnull((select price from t_productdata where proid = '%@'),'0')/cast(ifnull(uniterate,'1') as double) from t_unite  where proid = '%@' and unitename = '%@'";

//更新单据列表订单号
static NSString* IS_SQL_updateBillList1 = @"update t_SwapBillList set Status = '1' where SwapCode = '%@'";
static NSString* IS_SQL_updateBillList2 = @"update t_SwapBillList set SwapCode = '%@' where SwapCode = '%@'";

//更新单据详情订单号
static NSString* IS_SQL_updateBillDetail = @"update t_SwapBillDtl set SwapCode = '%@' where SwapCode = '%@'";

//获取详情订单ID
static NSString* IS_SQL_getBillDetailId = @"select ifnull(max(DtlId),'0') from t_SwapBillDtl";

//根据条码获取产品
static NSString* IS_SQL_getProductByBarCode = @"select * from t_productdata where Weight = '%@'";


//根据Partner 日期获取订单
static NSString* IS_SQL_getOrderList = @"select * from t_SwapBillList where ";

//获取详单列表
static NSString* IS_SQL_getOrderDetailList = @"select * from t_SwapBillDtl where  SwapCode = '%@'";

//根据ID获取客户资料
static NSString* IS_SQL_getPartnerById = @"select * from t_PartnerData where  PartnerId = '%@'";

@implementation ISOrderViewModel

- (NSString*)generateSaleOrderNoByType:(ISOrderType)type{
    
    int index = 0;

    NSString * prefix = @"";
    NSString * yyyyMMdd = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMdd"];
    NSArray * list;
    
    switch (type) {
        case ISOrderTypeNormal:
            prefix = @"T";
            list =  [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getMaxOrderNo,[NSString stringWithFormat:@"%@%@",prefix,yyyyMMdd]]];
            break;
        case ISOrderTypeReturn:
            prefix = @"R";
            list =  [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getMaxReturnOrderNo,[NSString stringWithFormat:@"%@%@",prefix,yyyyMMdd]]];
            break;
        default:
            break;
    }
    
    if (list.count) {
        index = [[list firstObject] intValue];
    }
    return [NSString stringWithFormat:@"%@%@%04d",prefix,yyyyMMdd,++index];
}

- (NSArray*)fetchCustomerListByWord:(NSString*)text type:(ISSearchFieldType)type{
    switch (type) {
        case ISSearchFieldTypeCustomer:
            return  [[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:[NSString stringWithFormat:IS_SQL_getCustomerList,text,text,text] withEntity:[ISTypeMapper modelMapDictionary][@"t_PartnerData"]];
        case ISSearchFieldTypeProduct:
            return  [[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:[NSString stringWithFormat:IS_SQL_getProductList,text,text,text] withEntity:[ISTypeMapper modelMapDictionary][@"t_ProductData"]];
            break;
        default:
            return nil;
    }
}

- (ISProductDataModel*)fetchProductModelById:(NSString*)productId{
    return [[[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:[NSString stringWithFormat:IS_SQL_getProductById,productId] withEntity:NSStringFromClass([ISProductDataModel class])] firstObject];
}

- (NSArray*)fetchUnitByProductId:(NSString*)productId smallUnit:(BOOL)smallUnit{
    NSArray * list = [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getUnitByProductId,productId]];
    if (smallUnit) {
        list = [[list reverseObjectEnumerator] allObjects];
    }
    return list;
}

- (BOOL)checkIfSmallUnit:(NSString*)proId unit:(NSString*)uni{
    return NO;
}

- (NSString*)fetchLocalPriceByProId:(NSString*)proId unit:(NSString*)unit{
    
    NSString * localPrice = [[[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getLocalPrice,proId,proId,unit]] firstObject];    
    return [NSString stringWithFormat:@"%.2f",[localPrice floatValue]];
}

- (NSString*)generateParametersForOrderByList:(NSArray*)list{
    
    NSMutableArray * dataList = [NSMutableArray array];
    NSMutableArray * paramList = [NSMutableArray array];
    
    for(id obj in list){
        if ([obj isKindOfClass:[ISOrderDetailModel class]]) {
            [dataList addObject:obj];
        }
    }
    
    for(int i = 0; i < dataList.count; i++){
        ISOrderDetailModel * detailModel = dataList[i];
        //数量为0
        if ([detailModel.ProQuantity isEqualToString:@"0"]) {
            [paramList addObject:[NSString stringWithFormat:@"%@,%@",detailModel.ProId,
                                  detailModel.ProUnite]];
        //数量不为0
        }else{
            [paramList addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,",detailModel.ProId,
                                  detailModel.ProQuantity,
                                  detailModel.ProUnite,
                                  detailModel.Amt,
                                  @"0",
                                  detailModel.tejia]];
        }
        //赠品
        if (![detailModel.LargessUnite IS_isEmptyObject]) {
            [paramList addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,",detailModel.ProId,
                                  detailModel.LargessQty,
                                  detailModel.LargessUnite,
                                  detailModel.Amt,
                                  @"1",
                                  detailModel.tejia]];
        }
    }
    return [paramList componentsJoinedByString:@"|"];
}

- (void)updateOrderWithNewNo:(NSString*)newNo oldNo:(NSString*)oldNo{
    
    [[ISDataBaseHelper sharedInstance] updateDataBaseBySQL:[NSString stringWithFormat:IS_SQL_updateBillList1,oldNo]];
    [[ISDataBaseHelper sharedInstance] updateDataBaseBySQL:[NSString stringWithFormat:IS_SQL_updateBillList2,newNo,oldNo]];
    [[ISDataBaseHelper sharedInstance] updateDataBaseBySQL:[NSString stringWithFormat:IS_SQL_updateBillDetail,newNo,oldNo]];
}

- (BOOL)checkOrderNoWithNo:(NSString*)orderNo type:(ISOrderType)type{
    
    NSString * regExpression = @"";
    switch (type) {
        case ISOrderTypeNormal:
            regExpression = @"^S\\d{12}$";
            break;
        case ISOrderTypeReturn:
            regExpression = @"^RS\\d{12}$";
            break;
        default:
            break;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regExpression];
    return [predicate evaluateWithObject:orderNo];
}


- (NSString*)generateDetailIdWithOrderNo:(NSString*)orderNo{
    NSArray * list =  [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:IS_SQL_getBillDetailId];
    int index = [[list firstObject] intValue];
    return [NSString stringWithFormat:@"%d",++index];
}

- (ISProductDataModel*)fetchProductByBarCode:(NSString*)barCode{
    return [[[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:[NSString stringWithFormat:IS_SQL_getProductByBarCode,barCode] withEntity:NSStringFromClass([ISProductDataModel class])] firstObject];
}

- (NSArray*)fetchOrderListByPartner:(ISParterDataModel *)partner date:(NSString *)date{
    NSMutableString * strSQL = [IS_SQL_getOrderList mutableCopy];
    NSMutableArray * params = [NSMutableArray array];
    if (partner) {
        [params addObject:[NSString stringWithFormat:@" PartnerId = '%@' ",partner.PartnerId]];
    }
    
    if (![NSString stringIsNilOrEmpty:date]) {
        [params addObject:[NSString stringWithFormat:@" CRE_DATE like '%@%%' ",date]];
    }
    [strSQL appendString:[params componentsJoinedByString:@" AND "]];
    return [[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:strSQL withEntity:NSStringFromClass([ISOrderDataModel class])];
}

- (NSArray*)fetchOrderDetailListByOrderNo:(NSString*)orderNo{
    return [[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:[NSString stringWithFormat:IS_SQL_getOrderDetailList,orderNo] withEntity:NSStringFromClass([ISOrderDetailModel class])];
}

- (ISParterDataModel*)fetchPartnerById:(NSString*)partnerId{
    return [[[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:[NSString stringWithFormat:IS_SQL_getPartnerById,partnerId] withEntity:NSStringFromClass([ISParterDataModel class])] firstObject];
}

@end
