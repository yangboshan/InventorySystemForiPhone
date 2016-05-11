//
//  ISOrderViewModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderViewModel.h"

@interface ISOrderViewModel()

@end

static NSString* IS_SQL_getCustomerList = @"select * from t_PartnerData where pycode like '%%%@%%' or partnercode like '%%%@%%' or PartnerName like '%%%@%%'";
static NSString* IS_SQL_getProductList = @"select * from t_ProductData where pycode like '%%%@%%' or partnercode like '%%%@%%'";
static NSString* IS_SQL_getMaxOrderNo = @"select ifnull(max(SwapCode),0)  from t_SwapBillList where SwapCode like '%@%%'";



@implementation ISOrderViewModel

- (NSString*)generateSaleOrderNo{
    
    int index = 0;
    NSString * yyyyMMdd = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMdd"];
    NSArray * list =  [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getMaxOrderNo,[NSString stringWithFormat:@"T%@",yyyyMMdd]]];
    
    if (list.count) {
        index = [[list firstObject] intValue];
        if (index) {
            index++;
        }
    }
    return [NSString stringWithFormat:@"T%@%04d",yyyyMMdd,++index];
}

- (NSString*)generateReOrderNo{
    int index = 0;
    NSString * yyyyMMdd = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMdd"];
    NSArray * list =  [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_getMaxOrderNo,[NSString stringWithFormat:@"RS%@",yyyyMMdd]]];
    
    if (list.count) {
        index = [[list firstObject] intValue];
        if (index) {
            index++;
        }
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

@end
