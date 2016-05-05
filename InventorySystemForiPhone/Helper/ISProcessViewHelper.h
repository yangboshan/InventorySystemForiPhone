//
//  ISProcessViewHelper.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ISProcessViewHelper : NSObject

+ (instancetype)sharedInstance;

- (void)showProcessViewInView:(UIView*)view;

- (void)hideProcessViewInView:(UIView*)view;

- (void)showProcessViewWithText:(NSString*)text InView:(UIView*)view;

@end
