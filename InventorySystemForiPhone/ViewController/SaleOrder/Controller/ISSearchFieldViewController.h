//
//  ISSearchFieldViewController.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISOrderViewModel.h"



typedef void(^ISSearchFieldBlock)(id object);

@interface ISSearchFieldViewController : UIViewController

- (instancetype)initWithType:(ISSearchFieldType)type finish:(ISSearchFieldBlock)block;

@end
