//
//  ISProductDataModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISBaseModel.h"


@interface ISProductDataModel : ISBaseModel

@property (nonatomic,strong) NSString * ProId;

@property (nonatomic,strong) NSString * ProCode;

@property (nonatomic,strong) NSString * ProName;

@property (nonatomic,strong) NSString * Type;

@property (nonatomic,strong) NSString * Weight;

@property (nonatomic,strong) NSString * ProKind;

@property (nonatomic,strong) NSString * Price;

@property (nonatomic,strong) NSString * ProPoint;

@property (nonatomic,strong) NSString * ProRemark;

@property (nonatomic,strong) NSString * RefDate;

@property (nonatomic,strong) NSString * OnSale;

@property (nonatomic,strong) NSString * DelFlag;

@property (nonatomic,strong) NSString * CRE_USER;

@property (nonatomic,strong) NSString * CRE_DATE;

@property (nonatomic,strong) NSString * UPD_USER;

@property (nonatomic,strong) NSString * UPD_DATE;

@property (nonatomic,strong) NSString * PriceChg;

@property (nonatomic,strong) NSString * PriceChgDate;

@property (nonatomic,strong) NSString * ProKind2;

@property (nonatomic,strong) NSString * Guarantee;

@property (nonatomic,strong) NSString * Company;

@property (nonatomic,strong) NSString * PYCode;

@property (nonatomic,strong) NSString * SortKey;

@property (nonatomic,strong) NSString * xPrice;

@property (nonatomic,strong) NSString * SalePriceX;

@property (nonatomic,strong) NSString * SalePriceSug;

@property (nonatomic,strong) NSString * OutUnite;

@end
