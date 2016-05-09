//
//  ISDataSyncModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/6.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ISDataSyncStatus){
    ISDataSyncStatusDefault = 0,
    ISDataSyncStatusSyncing = 1,
    ISDataSyncStatusFinished = 2,
    ISDataSyncStatusError = 3
};

@interface ISDataSyncModel : NSObject

/**
 *  当前同步状态
 */
@property (nonatomic,assign,readonly) ISDataSyncStatus status;

/**
 *  进度
 */
@property (nonatomic,assign,readonly) float progress;

+ (instancetype)sharedInstance;

/**
 *  开始同步
 */
- (void)startSync;

@end
