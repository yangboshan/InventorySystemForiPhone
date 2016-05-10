//
//  ISOrderViewModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISOrderViewModel : NSObject

- (instancetype)sharedInstance;

- (NSString*)generateOrderNo;

- (NSArray*)fetchCustomerListByWord:(NSString*)text;

@end
