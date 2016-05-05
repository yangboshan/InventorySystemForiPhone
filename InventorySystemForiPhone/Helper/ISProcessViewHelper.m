//
//  ISProcessViewHelper.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISProcessViewHelper.h"

@implementation ISProcessViewHelper

+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    static ISProcessViewHelper * sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[ISProcessViewHelper alloc] init];
    });
    return sharedInstance;
}

- (void)showProcessViewInView:(UIView*)view{
    [self hideProcessViewInView:view];
    MBProgressHUD * hudView = [[MBProgressHUD alloc] initWithView:view];
    hudView.removeFromSuperViewOnHide = YES;
    [view addSubview:hudView];
    [hudView show:YES];
}

- (void)hideProcessViewInView:(UIView*)view{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

- (void)showProcessViewWithText:(NSString*)text InView:(UIView*)view{
    [self hideProcessViewInView:view];
    MBProgressHUD * hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = text;
    hudView.removeFromSuperViewOnHide = YES;
    [hudView hide:YES afterDelay:2];
}

@end
