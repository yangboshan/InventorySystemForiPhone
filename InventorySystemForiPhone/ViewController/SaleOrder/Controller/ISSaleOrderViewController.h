//
//  ISSaleOrderViewController.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISOrderDataModel;

@interface ISSaleOrderViewController : UIViewController

@property (nonatomic, assign) BOOL isFromQuery;
@property (nonatomic, strong) ISOrderDataModel * orderDataModel;

@end
