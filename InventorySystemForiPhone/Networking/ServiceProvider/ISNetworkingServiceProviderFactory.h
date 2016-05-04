//
//  ISNetworkingServiceProviderFactory.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISNetworkingBaseServiceProvider.h"


@interface ISNetworkingServiceProviderFactory : NSObject

+ (instancetype)sharedInstance;

/**
 *  retrive serviceProvider by ID
 *
 *  @param identifier
 *
 *  @return ISNetworkingBaseServiceProvider
 */
- (ISNetworkingBaseServiceProvider<ISNetworkingBaseServiceProviderProtocol>*)serviceProviderByIdentifier:(NSString*)identifier;

@end 
