//
//  ISLoginViewModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISLoginViewModel.h"

@implementation ISLoginViewModel

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISLoginViewModel *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISLoginViewModel alloc] init];
    });
    return sharedInstance;
}

- (BOOL)checkLoginInfoByUserName:(NSString*)userName userPsw:(NSString*)userPsw{
    if (![userName IS_isEmptyObject] && ![userPsw IS_isEmptyObject]) {
        return YES;
    }
    return NO;
}

@end
