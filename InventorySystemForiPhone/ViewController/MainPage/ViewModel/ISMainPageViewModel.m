//
//  ISMainPageViewModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISMainPageViewModel.h"

@interface ISMainPageViewModel()
@property (nonatomic,strong) NSArray* pList;
@end

@implementation ISMainPageViewModel

- (NSArray*)fetchFormatDataSource{
    
    NSMutableArray* formatList = [NSMutableArray array];
    
    if ([ISSettingManager sharedInstance].currentUser) {
        NSArray* privilege = [ISSettingManager sharedInstance].currentUser[@"privilege"];
        for(NSDictionary* d in self.pList){
            if ([d[@"flag"] isEqualToString:@"1"]) {
                if ([privilege containsObject:d[@"code"]]) {
                    [formatList addObject:d];
                }
            }
        }
    }else{
        for(NSDictionary* d in self.pList){
            if ([d[@"flag"] isEqualToString:@"1"]) {
                [formatList addObject:d];
            }
        }
    }
    return formatList;
}

#pragma mark - getter

- (BOOL)hasPrivilegeForSyncData{
    return [[ISSettingManager sharedInstance].currentUser[@"privilege"] containsObject:@"Q03_P01"];
}

- (BOOL)hasPrivilegeForReport{
    return [[ISSettingManager sharedInstance].currentUser[@"privilege"] containsObject:@"Q02_P01"];
}

- (BOOL)hasPrivilegeForModifyPrice{
    return [[ISSettingManager sharedInstance].currentUser[@"privilege"] containsObject:@"Q02_P01"];
}

- (BOOL)shouldLocation{
    return [[ISSettingManager sharedInstance].currentUser[@"privilege"] containsObject:@"Q04_P02"];
}

- (BOOL)shouldShootPhoto{
    return [[ISSettingManager sharedInstance].currentUser[@"privilege"] containsObject:@"Q00_P00"];
}

- (NSArray*)pList{
    if (_pList == nil) {
        _pList = @[@{@"code":@"Q01_P02",
                     @"desc":NSLocalizedString(@"ISSaleOrderViewController", nil),
                     @"flag":@"1",
                     @"type":@(0),
                     @"vc":@"ISSaleOrderViewController",
                     @"bg":HEXCOLOR(0x4192F1),
                     @"icon":@"main_list_icon1"},
                   
                   @{@"code":@"Q01_P04",
                     @"desc":NSLocalizedString(@"ISReturnOrderViewController", nil),
                     @"flag":@"1",
                     @"type":@(1),
                     @"vc":@"ISSaleOrderViewController",
                     @"bg":HEXCOLOR(0x1CCE6F),
                     @"icon":@"main_list_icon3"},
                   
                   @{@"code":@"Q01_P03",
                     @"desc":NSLocalizedString(@"ISQueryOrderViewController", nil),
                     @"flag":@"1",
                     @"vc":@"ISQueryOrderViewController",
                     @"bg":HEXCOLOR(0xF9A743),
                     @"icon":@"main_list_icon2"},
                   
                   @{@"code":@"Q02_P01",
                     @"desc":@"报表",
                     @"flag":@"1",
                     @"vc":@"",
                     @"bg":HEXCOLOR(0x40AB58),
                     @"icon":@"main_list_icon4"},
                   
                   @{@"code":@"Q03_P01",
                     @"desc":NSLocalizedString(@"ISDataSyncViewController", nil),
                     @"flag":@"1",
                     @"vc":@"ISDataSyncViewController",
                     @"bg":HEXCOLOR(0x85AED4),
                     @"icon":@"main_list_icon5"},
                   
                   @{@"code":@"Q04_P01",
                     @"desc":@"必须拍照",
                     @"flag":@"0"},
                   
                   @{@"code":@"Q04_P02",
                     @"desc":@"必须定位",
                     @"flag":@"0"},
                   
                   @{@"code":@"Q00_P00",
                     @"desc":@"修改单价",
                     @"flag":@"0"}];
    }
    return _pList;
}


@end
