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
@property(nonatomic,readonly,getter = isFirstRun) BOOL firstRun;

/**
 *  current login status
 */
@property(nonatomic,getter = isLogined) BOOL logined;

/**
 *  current logined user
 */
@property(nonatomic,strong) NSMutableDictionary* currentUser;

+(instancetype)sharedInstance;

@end
