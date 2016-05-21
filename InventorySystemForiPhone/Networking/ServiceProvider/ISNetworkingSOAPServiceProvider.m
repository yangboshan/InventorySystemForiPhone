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
    return [ISSettingManager sharedInstance].serviceUrl;
}

- (NSString*)onlineServiceVersion{
    return @"1.0";
}

@end
