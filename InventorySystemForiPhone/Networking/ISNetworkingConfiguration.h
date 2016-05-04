//
//  ISNetworkingConfiguration.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#ifndef ISNetworkingConfiguration_h
#define ISNetworkingConfiguration_h

typedef NS_ENUM(NSInteger, ISAppType) {
    ISAppTypeInventory
};

typedef NS_ENUM(NSUInteger, ISURLResponseStatus){
    ISURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的RTApiBaseManager来决定。
    ISURLResponseStatusErrorTimeout,
    ISURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kISNetworkingTimeoutSeconds = 20.0f;
static BOOL kISShouldCache = NO;
static NSTimeInterval kISCacheOutdateTimeSeconds = 300; // cache过期时间
static NSUInteger kISCacheCountLimit = 1000; // 最多1000条cache


#endif /* ISNetworkingConfiguration_h */
