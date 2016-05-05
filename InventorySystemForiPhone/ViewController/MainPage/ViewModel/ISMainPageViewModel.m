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
    return YES;
}

- (BOOL)hasPrivilegeForReport{
    return YES;
}

- (BOOL)shouldLocation{
    return YES;
}

- (BOOL)shouldShootPhoto{
    return YES;
}


- (NSArray*)pList{
    if (_pList == nil) {
        _pList = @[@{@"code":@"Q01_P02",@"desc":@"销售抄单",@"flag":@"1",@"vc":@"ISSaleOrderViewController",@"bg":HEXCOLOR(0x4192F1)},
                   @{@"code":@"Q01_P03",@"desc":@"查询单据",@"flag":@"1",@"vc":@"ISQueryOrderViewController",@"bg":HEXCOLOR(0xF9A743)},
                   @{@"code":@"Q01_P04",@"desc":@"退货抄单",@"flag":@"1",@"vc":@"ISReturnOrderViewController",@"bg":HEXCOLOR(0x1CCE6F)},
                   @{@"code":@"Q02_P01",@"desc":@"报表",@"flag":@"1",@"vc":@"",@"bg":HEXCOLOR(0x40AB58)},
                   @{@"code":@"Q03_P01",@"desc":@"同步处理",@"flag":@"1",@"vc":@"",@"bg":HEXCOLOR(0x85AED4)},
                   @{@"code":@"Q04_P01",@"desc":@"必须拍照",@"flag":@"0"},
                   @{@"code":@"Q04_P02",@"desc":@"必须定位",@"flag":@"0"}];
    }
    return _pList;
}

@end
