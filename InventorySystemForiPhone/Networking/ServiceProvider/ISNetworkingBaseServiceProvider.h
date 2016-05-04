//
//  ISNetworkingBaseServiceProvider.h
//  InventorySystemForiPhone

//  API 提供方封装基类

//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISNetworkingBaseServiceProviderProtocol <NSObject>

@property (nonatomic,readonly) NSString * onlineServiceUrl;
@property (nonatomic,readonly) NSString * onlineServiceVersion;

@end

@interface ISNetworkingBaseServiceProvider : NSObject

/**
 *  serviceUrl
 *
 *  @return serviceUrl
 */
@property (nonatomic,readonly) NSString * serviceUrl;

/**
 *  serviceVersion
 *
 *  @return serviceVersion
 */
@property (nonatomic,readonly) NSString * serviceVersion;

@property (nonatomic, weak) id<ISNetworkingBaseServiceProviderProtocol> child;


@end
