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
 *  生成订单号
 *
 *  @return 订单号
 */
- (NSString*)generateSaleOrderNo;

/**
 *  生成退单号
 *
 *  @return 退单号
 */
- (NSString*)generateReOrderNo;

/**
 *  根据关键字及类型获取列表
 *
 *  @param text 关键字
 *  @param type 类型
 *
 *  @return 列表
 */
- (NSArray*)fetchCustomerListByWord:(NSString*)text type:(ISSearchFieldType)type;


/**
 *  获取产品Model
 *
 *  @param 产品ID
 *
 *  @return 产品Model
 */
- (ISProductDataModel*)fetchProductModelById:(NSString*)productId;


/**
 *  获取单位列表 并排序
 *
 *  @param productId 产品ID
 *  @param smallUnit 是否小单位
 *
 *  @return 列表
 */
- (NSArray*)fetchUnitByProductId:(NSString*)productId smallUnit:(BOOL)smallUnit;


/**
 *  判断是否小单位
 *
 *  @param proId 产品ID
 *  @param unit  单位
 *
 *  @return 布尔值
 */
- (BOOL)checkIfSmallUnit:(NSString*)proId unit:(NSString*)unit;


/**
 *  获取本地价格
 *
 *  @param proId 产品ID
 *  @param unit 单位
 *
 *  @return 价格
 */
- (NSString*)fetchLocalPriceByProId:(NSString*)proId unit:(NSString*)unit;


@end
