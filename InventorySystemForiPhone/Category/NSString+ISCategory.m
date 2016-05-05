//
//  NSString+TACategory.m
//  TripAway
//
//  Created by yangboshan on 15/3/17.
//  Copyright (c) 2015年 bcinfo. All rights reserved.
//

#import "NSString+ISCategory.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (ISCategory)

+ (BOOL)stringIsNilOrEmpty:(NSString *)aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    return NO;
}

- (NSString*)md5{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}

- (NSString *)trim{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

- (BOOL)isValidEmail{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

- (BOOL)isVAlidPhoneNumber{
    NSString *regex = @"^(1[3-8][0-9])\\d{8}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}
@end
