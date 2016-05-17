//
//  ISAddProductViewController.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/11.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ISAddProductType){
    //new
    ISAddProductTypeNew = 0,
    //scan
    ISAddProductTypeScan
};

typedef void(^ISAddProductBlock)(id object);

@class ISParterDataModel;

@interface ISAddProductViewController : UIViewController

@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, strong) ISParterDataModel * partnerModel;

- (instancetype)initWithType:(ISAddProductType)type block:(ISAddProductBlock)block;

@end
