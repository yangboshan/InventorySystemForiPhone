//
//  ISSQLiteManager.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/18.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSQLiteManager.h"

@implementation ISSQLiteManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISSQLiteManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISSQLiteManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        NSInteger locationVersion = [ISSettingManager sharedInstance].dBVersion;
        if (IS_SQLITE_DB_VERSION != locationVersion) {
            if (locationVersion < 1) {
                [ISSettingManager sharedInstance].dBVersion = 1;
            }else{
                [self upgrateDB];
            }
        }
    }
    return self;
}

- (void)upgrateDB{
    NSInteger locationVersion = [ISSettingManager sharedInstance].dBVersion;
    switch (locationVersion) {
        case 1:
            [self upgrateDBForVersion1];
            break;
        default:
            break;
    }
    [ISSettingManager sharedInstance].dBVersion = IS_SQLITE_DB_VERSION;
}

- (void)upgrateDBForVersion1{
    
}


@end
