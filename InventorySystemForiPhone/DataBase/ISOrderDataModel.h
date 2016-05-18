//
//  ISOrderDataModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/15.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISBaseModel.h"

@interface ISOrderDataModel : ISBaseModel

@property (nonatomic, copy) NSString * SwapCode;

@property (nonatomic, copy) NSString * SwapDate;

@property (nonatomic, copy) NSString * PartnerId;

@property (nonatomic, copy) NSString * PartnerBillCode;

@property (nonatomic, copy) NSString * sumAmt;

@property (nonatomic, copy) NSString * Status;

@property (nonatomic, copy) NSString * Remark;

@property (nonatomic, copy) NSString * CRE_USER;

@property (nonatomic, copy) NSString * CRE_DATE;

@property (nonatomic, copy) NSString * UPD_USER;

@property (nonatomic, copy) NSString * UPD_DATE;

@property (nonatomic, copy) NSString * recAmt;

@property (nonatomic, copy) NSString * giveAmt;

@property (nonatomic, copy) NSString * backBillStatus;

@property (nonatomic, copy) NSString * outStatus;

@property (nonatomic, copy) NSString * freeAmt;

@property (nonatomic, copy) NSString * getAmt;

@property (nonatomic, copy) NSString * outDate;

@property (nonatomic, copy) NSString * backDate;

@property (nonatomic, copy) NSString * PrintCount;

@property (nonatomic, copy) NSString * SwapType;

@property (nonatomic, copy) NSString * sumProPoint;

@property (nonatomic, copy) NSString * PayAmt;

@property (nonatomic, copy) NSString * PayType;

@end
