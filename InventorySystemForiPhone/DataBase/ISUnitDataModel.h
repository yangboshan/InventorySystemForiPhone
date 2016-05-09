//
//  ISUnitDataModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISBaseModel.h"

@interface ISUnitDataModel : ISBaseModel

@property (nonatomic,copy) NSString * proid;

@property (nonatomic,copy) NSString * UniteName;

@property (nonatomic,copy) NSString * Uniterate;

@property (nonatomic,copy) NSString * CRE_USER;

@property (nonatomic,copy) NSString * CRE_DATE;

@property (nonatomic,copy) NSString * UPD_USER;

@property (nonatomic,copy) NSString * UPD_DATE;

@property (nonatomic,copy) NSString * UniteType;

@end

