//
//  ISNetworkingSOAPServiceProvider.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingSOAPServiceProvider.h"

@implementation ISNetworkingSOAPServiceProvider

- (NSString*)onlineServiceUrl{
    NSString * servieUrl = [ISSettingManager sharedInstance].serviceUrl;
    if (servieUrl) {
        if (![servieUrl IS_isEmptyObject]) {
            return [ISSettingManager sharedInstance].serviceUrl;
        }
    }
//    return @"http://szllrj.vicp.cc:1897/LinoonInvServiceSJ/Service1.asmx";
    return @"http://221.224.95.14:1897/linooninvservicesj/service1.asmx";
}

- (NSString*)onlineServiceVersion{
    return @"1.0";
}

@end
