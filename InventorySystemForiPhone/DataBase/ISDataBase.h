//
//  ISDataBase.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDataBase.h"


@interface ISDataBase : NSObject

+ (instancetype)sharedInstance;

- (FMDatabase*)dataBase;


@end
