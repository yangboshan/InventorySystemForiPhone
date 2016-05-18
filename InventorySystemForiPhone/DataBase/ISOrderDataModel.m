//
//  ISOrderDataModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/15.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderDataModel.h"

@implementation ISOrderDataModel

- (NSArray*)primaryKey{
    return @[@"SwapCode"];
}

- (instancetype)init{
    if (self = [super init]) {
        _SwapDate = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMddHHmmss"];
        _CRE_USER = [ISSettingManager sharedInstance].currentUser[@"userId"];
        _CRE_DATE = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMddHHmmss"];
        _UPD_USER = [ISSettingManager sharedInstance].currentUser[@"userName"];
        _UPD_DATE = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMddHHmmss"];
        _Status = @"0";
    }
    return self;
}

@end
