//
//  ISAddProductViewController.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/11.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ISAddProductType){
    //新建
    ISAddProductTypeNew = 0,
    //扫码
    ISAddProductTypeScan
};

typedef void(^ISAddProductBlock)(id object);

@class ISParterDataModel;

@interface ISAddProductViewController : UIViewController


//商品ID 扫码用
@property (nonatomic, copy) NSString * productId;

//是否小单位
@property (nonatomic, assign) BOOL smallUnit;

//客户资料
@property (nonatomic, strong) ISParterDataModel * partnerModel;

- (instancetype)initWithType:(ISAddProductType)type block:(ISAddProductBlock)block;

@end
