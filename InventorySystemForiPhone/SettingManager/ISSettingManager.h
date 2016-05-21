//
//  ISSettingManager.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSettingManager : NSObject

/**
 *  first launch flag
 */
@property (nonatomic,readonly,getter = isFirstRun) BOOL firstRun;

/**
 *  current login status
 */
@property (nonatomic,getter = isLogined) BOOL logined;

/**
 *  current logined user
 */
@property (nonatomic,strong) NSMutableDictionary * currentUser;

/**
 *  dataBase version
 */
@property (nonatomic,assign) NSInteger dBVersion;

/**
 *  last Sync Date
 */
@property (nonatomic,strong) NSDate * lastSyncDate;

/**
 *  Service URL
 */
@property (nonatomic,strong) NSString * serviceUrl;


+ (instancetype)sharedInstance;

@end
