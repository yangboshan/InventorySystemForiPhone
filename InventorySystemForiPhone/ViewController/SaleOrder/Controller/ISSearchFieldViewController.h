//
//  ISSearchFieldViewController.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ISSearchFieldType){
    ISSearchFieldTypeCustomer = 0,
};

typedef void(^ISSearchFieldBlock)(NSString* result);

@interface ISSearchFieldViewController : UIViewController

- (instancetype)initWithType:(ISSearchFieldType)type finish:(ISSearchFieldBlock)block;

@end
