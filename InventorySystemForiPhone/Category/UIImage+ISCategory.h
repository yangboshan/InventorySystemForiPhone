//
//  UIImage+ISCategory.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/13.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ISCategory)

- (UIImage*)fixOrientation;

- (UIImage*)waterMarkImageWithLocation:(NSString*)location;

@end
