//
//  ISOrderDetailModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/15.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderDetailModel.h"

@implementation ISOrderDetailModel

- (NSArray*)primaryKey{
    return @[@"ProId",@"SwapCode"];
}

- (instancetype)init{
    if (self = [super init]) {
        _ProQuantity = @"1";
        _tejia = @"0";
    }
    return self;
}

@end
