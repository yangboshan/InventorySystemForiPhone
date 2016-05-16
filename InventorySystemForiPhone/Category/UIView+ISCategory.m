//
//  UIView+TACategory.m
//  TripAway
//
//  Created by yangboshan on 15/7/7.
//  Copyright (c) 2015年 yangbs. All rights reserved.
//

#import "UIView+ISCategory.h"

@implementation UIView (ISCategory)

- (UIViewController *)viewController{
    
    UIResponder *next = [self nextResponder];
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

@end
