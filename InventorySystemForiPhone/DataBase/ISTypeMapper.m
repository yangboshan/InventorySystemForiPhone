//
//  ISTypeMapper.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISTypeMapper.h"

@interface ISTypeMapper()
@end

@implementation ISTypeMapper

+ (NSDictionary*)modelMapDictionary{
    return @{@"t_PartnerData":@"ISParterDataModel",
             @"t_ProductData":@"ISProductDataModel",
             @"t_Unite":@"ISUnitDataModel",
             @"t_SwapBillList":@"ISOrderDataModel",
             @"t_SwapBillDtl":@"ISOrderDetailModel"};
}

+ (NSDictionary*)formatterMapDictionary{
    return @{@"t_PartnerData":@"ISDataSyncPartnerFormatter",
             @"t_ProductData":@"ISDataSyncProductFormatter",
             @"t_Unite":@"ISDataSyncUnitFormatter"};
}

@end
