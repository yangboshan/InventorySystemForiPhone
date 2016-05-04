//
//  ISNetworkingBaseServiceProvider.m
//  InventorySystemForiPhone

//  API 提供方封装基类

//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingBaseServiceProvider.h"

@implementation ISNetworkingBaseServiceProvider

/**
 *  初始化方法
 *  强制检查子类是否实现了协议
 *  @return instance
 */
- (instancetype)init{
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(ISNetworkingBaseServiceProviderProtocol)]) {
            self.child = (id<ISNetworkingBaseServiceProviderProtocol>)self;
        }else{
            NSAssert(NO, @"子类必须继承协议");
        }
    }
    return self;
}


- (NSString*)serviceUrl{
    return self.child.onlineServiceUrl;
}


- (NSString*)serviceVersion{
    return self.child.onlineServiceVersion;
}

@end
