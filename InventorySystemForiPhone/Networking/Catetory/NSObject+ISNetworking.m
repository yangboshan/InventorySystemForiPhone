//
//  NSObject+ISNetworking.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "NSObject+ISNetworking.h"

@implementation NSObject (ISNetworking)

- (id)IS_defaultValue:(id)defaultData{
    
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self IS_isEmptyObject]) {
        return defaultData;
    }
    return self;
}

- (BOOL)IS_isEmptyObject{
    
    if (self == nil) {
        return YES;
    }
    
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([[(NSString *)self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    return NO;
}

@end
