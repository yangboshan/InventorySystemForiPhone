//
//  ISSQLiteManager.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/18.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSInteger IS_SQLITE_DB_VERSION = 1;

@interface ISSQLiteManager : NSObject

+ (instancetype)sharedInstance;

@end
