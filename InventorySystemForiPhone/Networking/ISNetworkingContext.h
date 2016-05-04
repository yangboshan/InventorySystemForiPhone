
//
//  ISNetworkingContext.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISNetworkingConfiguration.h"


@interface ISNetworkingContext : NSObject

@property (nonatomic, copy) NSString *channelID;              //渠道号
@property (nonatomic, copy) NSString *appName;                //应用名称
@property (nonatomic, assign) ISAppType appType;

@property (nonatomic, copy, readonly) NSString *m;            //设备名称
@property (nonatomic, copy, readonly) NSString *o;            //系统名称
@property (nonatomic, copy, readonly) NSString *v;            //系统版本
@property (nonatomic, copy, readonly) NSString *cv;           //Bundle版本
@property (nonatomic, copy, readonly) NSString *from;         //请求来源，值都是@"mobile"
@property (nonatomic, copy, readonly) NSString *qtime;        //发送请求的时间
@property (nonatomic, copy, readonly) NSString *net;        


@property (nonatomic, readonly) BOOL isReachable;


+ (instancetype)sharedInstance;

@end
