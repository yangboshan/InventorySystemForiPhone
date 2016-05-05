//
//  ISGDataXMLHelper.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISGDataXMLHelper.h"

@implementation ISGDataXMLHelper

+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    static ISGDataXMLHelper * sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[ISGDataXMLHelper alloc] init];
    });
    return sharedInstance;
}

- (NSString*)safeStringFromData:(id)data{
    return (data == nil) ? @"" : [data IS_defaultValue:@""];
}

@end
