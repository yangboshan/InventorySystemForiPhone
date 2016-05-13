//
//  ISOrderBottomView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderBottomView.h"

@implementation ISOrderBottomView

- (void)awakeFromNib{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton*)obj;
            btn.layer.borderColor = BorderColor;
            btn.layer.borderWidth = 0.7;
            btn.titleLabel.font = LantingheiBold(13);
            
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
        }
    }];
}

@end
