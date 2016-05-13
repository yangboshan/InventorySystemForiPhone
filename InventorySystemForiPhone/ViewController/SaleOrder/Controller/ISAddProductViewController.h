//
//  ISAddProductViewController.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/11.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ISAddProductType){
    ISAddProductTypeNew = 0,
    ISAddProductTypeScan
};

typedef void(^ISAddProductBlock)(id object);
@interface ISAddProductViewController : UIViewController

- (instancetype)initWithType:(ISAddProductType)type block:(ISAddProductBlock)block;

@end
