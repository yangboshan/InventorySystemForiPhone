//
//  ISAddProductViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/11.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISAddProductViewController.h"

@interface ISAddProductViewController ()
@property (nonatomic, copy) ISAddProductBlock block;
@property (nonatomic, assign) ISAddProductType type;
@end

@implementation ISAddProductViewController

#pragma mark - life Cycle

- (instancetype)initWithType:(ISAddProductType)type block:(ISAddProductBlock)block{
    if (self = [super init]) {
        self.block = block;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    [self.view setBackgroundColor:RGB(239, 244, 244)];
 
}

#pragma mark - 


@end
