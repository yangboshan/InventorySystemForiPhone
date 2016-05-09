//
//  NSDate+ISCategory.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISCategory)

- (NSString*)dateStringWithFormat:(NSString*)format;

+ (NSDate*)dateFromString:(NSString*)string withFormat:(NSString*)format;

+ (NSDate*)currentDate;

@end
