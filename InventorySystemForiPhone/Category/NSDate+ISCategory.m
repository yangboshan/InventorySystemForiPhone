//
//  NSDate+ISCategory.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "NSDate+ISCategory.h"

@implementation NSDate (ISCategory)

- (NSString*)dateStringWithFormat:(NSString*)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

+ (NSDate*)dateFromString:(NSString*)string withFormat:(NSString*)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}


@end
