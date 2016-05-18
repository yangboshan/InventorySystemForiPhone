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
    
    self.layer.borderColor = BorderColor;
    self.layer.borderWidth = 1.0;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton*)obj;
            btn.titleLabel.font = LantingheiBoldD(13);
            btn.tintColor = [UIColor grayColor];
            [btn setBackgroundColor:RGBA(240, 240, 240, 1)];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }];
}

@end
