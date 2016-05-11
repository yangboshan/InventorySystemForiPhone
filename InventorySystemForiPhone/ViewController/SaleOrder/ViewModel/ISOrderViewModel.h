//
//  ISOrderViewModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ISSearchFieldType){
    ISSearchFieldTypeCustomer = 0,
    ISSearchFieldTypeProduct = 1,
};

@interface ISOrderViewModel : NSObject

- (NSString*)generateSaleOrderNo;

- (NSString*)generateReOrderNo;

- (NSArray*)fetchCustomerListByWord:(NSString*)text type:(ISSearchFieldType)type;

@end
