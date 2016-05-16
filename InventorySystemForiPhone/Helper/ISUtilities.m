//
//  ISUtilities.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/15.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISUtilities.h"

@implementation ISUtilities

+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    static ISUtilities * sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[ISUtilities alloc] init];
    });
    return sharedInstance;
}

+ (float)getDynamicFontSize:(float)size{
    
    float final = size;
    if (ScreenWidth == 375.0) {
        ++final;
    }else if (ScreenWidth == 414.0){
        ++final;
    }else{}
    
    return final;
}

@end
