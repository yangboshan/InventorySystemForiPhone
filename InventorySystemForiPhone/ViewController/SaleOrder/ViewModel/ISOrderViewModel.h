//
//  ISOrderViewModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISProductDataModel;
@class ISParterDataModel;

typedef NS_ENUM(NSInteger,ISSearchFieldType){
    ISSearchFieldTypeCustomer = 0,
    ISSearchFieldTypeProduct = 1,
};

typedef NS_ENUM(NSInteger,ISOrderType){
    ISOrderTypeNormal = 0,
    ISOrderTypeReturn = 1
};

@interface ISOrderViewModel : NSObject

/**
 *  生成订单号
 *
 *  @return 订单号
 */
- (NSString*)generateSaleOrderNoByType:(ISOrderType)type;


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


/**
 *  生成单据上传Grid参数
 *
 *  @param list 单据列表
 *
 *  @return 参数
 */
- (NSString*)generateParametersForOrderByList:(NSArray*)list;


/**
 *  更新本地订单号
 *
 *  @param newNo 服务器返回的订单号
 *  @param oldNo 本地订单号
 *
 *  @return 
 */
- (void)updateOrderWithNewNo:(NSString*)newNo oldNo:(NSString*)oldNo;


/**
 *  检查服务器返回的订单号
 *
 *  @param orderNo 订单号
 *  @param type    类型
 *
 *  @return 布尔值
 */
- (BOOL)checkOrderNoWithNo:(NSString*)orderNo type:(ISOrderType)type;


/**
 *  生成详细列表的ID
 *
 *  @param orderNo 订单号
 *
 *  @return ID
 */
- (NSString*)generateDetailIdWithOrderNo:(NSString*)orderNo;

/**
 *  根据条码获取产品
 *
 *  @param barCode 条码
 *
 *  @return 产品Model
 */
- (ISProductDataModel*)fetchProductByBarCode:(NSString*)barCode;


/**
 *  获取订单列表
 *
 *  @param partner partnerModel
 *  @param date    date
 *
 *  @return 列表
 */
- (NSArray*)fetchOrderListByPartner:(ISParterDataModel*)partner date:(NSString*)date;


/**
 *  获取详单列表
 *
 *  @param orderNo 订单号
 *
 *  @return 列表
 */
- (NSArray*)fetchOrderDetailListByOrderNo:(NSString*)orderNo;


/**
 *  获取客户模型
 *
 *  @param partnerId ID
 *
 *  @return 模型
 */
- (ISParterDataModel*)fetchPartnerById:(NSString*)partnerId;


@end
