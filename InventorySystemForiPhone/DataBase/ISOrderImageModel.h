//
//  ISOrderImageModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/18.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISBaseModel.h"

@interface ISOrderImageModel : ISBaseModel

@property (nonatomic, copy) NSString * SwapCode;

@property (nonatomic, copy) NSString * ImageUrl;

@property (nonatomic, copy) NSString * Remark;

@property (nonatomic, copy) NSString * CRE_USER;

@property (nonatomic, copy) NSString * CRE_DATE;

@end
