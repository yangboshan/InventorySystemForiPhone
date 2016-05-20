//
//  ISOrderDetailModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/15.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISBaseModel.h"

@interface ISOrderDetailModel : ISBaseModel

@property (nonatomic, copy) NSString * DtlId;

@property (nonatomic, copy) NSString * SwapCode;  //订单号

@property (nonatomic, copy) NSString * ProId;     //产品ID

@property (nonatomic, copy) NSString * ProUnite;  //单位

@property (nonatomic, copy) NSString * ProQuantity; //数量

@property (nonatomic, copy) NSString * Amt;  //单价

@property (nonatomic, copy) NSString * tejia;  //特价

@property (nonatomic, copy) NSString * Remark;  //备注

@property (nonatomic, copy) NSString * LargessQty;   //赠送数量

@property (nonatomic, copy) NSString * LargessUnite; //赠送单位


@end
