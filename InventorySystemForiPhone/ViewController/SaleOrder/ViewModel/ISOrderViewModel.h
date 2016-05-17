//
//  ISOrderViewModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISProductDataModel;


typedef NS_ENUM(NSInteger,ISSearchFieldType){
    ISSearchFieldTypeCustomer = 0,
    ISSearchFieldTypeProduct = 1,
};

@interface ISOrderViewModel : NSObject

/**
 *  generate order no
 *
 *  @return order no
 */
- (NSString*)generateSaleOrderNo;

/**
 *  generate returnorder no
 *
 *  @return order no
 */
- (NSString*)generateReOrderNo;

/**
 *  quick match list by keyworkd
 *
 *  @param text keyword
 *  @param type type
 *
 *  @return matched list
 */
- (NSArray*)fetchCustomerListByWord:(NSString*)text type:(ISSearchFieldType)type;


/**
 *  fetch product model
 *
 *  @param productId
 *
 *  @return
 */
- (ISProductDataModel*)fetchProductModelById:(NSString*)productId;



- (NSArray*)fetchUnitByProductId:(NSString*)productId smallUnit:(BOOL)smallUnit;


@end
