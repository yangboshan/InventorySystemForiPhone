//
//  NSString+TACategory.h
//  TripAway
//
//  Created by yangboshan on 15/3/17.
//  Copyright (c) 2015年 bcinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ISCategory)

+ (BOOL)stringIsNilOrEmpty:(NSString *)aString;

- (NSString *)trim;

- (BOOL)isValidEmail;

- (BOOL)isVAlidPhoneNumber;

@end
