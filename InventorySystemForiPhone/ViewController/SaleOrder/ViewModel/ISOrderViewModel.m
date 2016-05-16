//
//  ISOrderViewModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderViewModel.h"
#import "ISProductDataModel.h"


@interface ISOrderViewModel()

@end

//客户列表
static NSString* IS_SQL_getCustomerList = @"select * from t_PartnerData where pycode like '%%%@%%' or partnercode like '%%%@%%' or PartnerName like '%%%@%%'";

//产品列表
static NSString* IS_SQL_getProductList = @"select * from t_ProductData where pycode like '%%%@%%' or procode like '%%%@%%' or ProName like '%%%@%%'";

//订单号
static NSString* IS_SQL_getMaxOrderNo = @"select substr(ifnull(max(SwapCode),'T197001010000'),10,4)  from t_SwapBillList where SwapCode like '%@%%'";

//根据ID获取产品
static NSString* IS_SQL_getProductById = @"select * from t_ProductData where proid = '%@'";

//根据产品获取单位
static NSString* IS_SQL_getUnitByProductId = @"select UniteName from t_unite where proid = '%@' order by Uniterate";

@implementation ISOrderViewModel

- (NSString*)generateSaleOrderNo{
    
    int index = 0;
    NSString * yyyyMMdd = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMdd"];
    NSArray * list =  [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getMaxOrderNo,[NSString stringWithFormat:@"T%@",yyyyMMdd]]];
    
    if (list.count) {
        index = [[list firstObject] intValue];
    }
    return [NSString stringWithFormat:@"T%@%04d",yyyyMMdd,++index];
}

- (NSString*)generateReOrderNo{
    int index = 0;
    NSString * yyyyMMdd = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMdd"];
    NSArray * list =  [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getMaxOrderNo,[NSString stringWithFormat:@"RS%@",yyyyMMdd]]];
    
    if (list.count) {
        index = [[list firstObject] intValue];
    }
    return [NSString stringWithFormat:@"RS%@%04d",yyyyMMdd,++index];
}


- (NSArray*)fetchCustomerListByWord:(NSString*)text type:(ISSearchFieldType)type{
    switch (type) {
        case ISSearchFieldTypeCustomer:
            return  [[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:[NSString stringWithFormat:IS_SQL_getCustomerList,text,text,text] withEntity:[ISTypeMapper modelMapDictionary][@"t_PartnerData"]];
        case ISSearchFieldTypeProduct:
            return  [[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:[NSString stringWithFormat:IS_SQL_getProductList,text,text] withEntity:[ISTypeMapper modelMapDictionary][@"t_ProductData"]];
            break;
        default:
            return nil;
    }
}

- (ISProductDataModel*)fetchProductModelById:(NSString*)productId{
    return [[[ISDataBaseHelper sharedInstance] fetchModelListFromSQL:IS_SQL_getProductById withEntity:NSStringFromClass([ISProductDataModel class])] firstObject];
}

- (NSArray*)fetchUnitByProductId:(NSString*)productId smallUnit:(BOOL)smallUnit{
    NSArray * list = [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getUnitByProductId,productId]];
    if (smallUnit) {
        list = [[list reverseObjectEnumerator] allObjects];
    }
    return list;
}



@end
