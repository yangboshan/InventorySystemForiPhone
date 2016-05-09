//
//  ISDataBase.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISDataBase.h"
#import "FMDataBase.h"


static FMDatabase *db = nil;

@implementation ISDataBase

+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    static ISDataBase * sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[ISDataBase alloc] init];
    });
    return sharedInstance;
}


-(FMDatabase*)dataBase{
    
    NSString* dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    dbPath = [dbPath stringByAppendingPathComponent:NSLocalizedString(@"DataBaseName", nil)];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"failed open db!");
        return nil;
    }
    return db;
}

@end
