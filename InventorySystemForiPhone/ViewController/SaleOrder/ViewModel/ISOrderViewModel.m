//
//  ISOrderViewModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderViewModel.h"

@implementation ISOrderViewModel

- (instancetype)sharedInstance{
    static dispatch_once_t token;
    static ISOrderViewModel * sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[ISOrderViewModel alloc] init];
    });
    return sharedInstance;
}

- (NSString*)generateOrderNo{
    return nil;
}


- (NSArray*)fetchCustomerListByWord:(NSString*)text{
    return nil;
}

@end
