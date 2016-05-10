//
//  ISMainPageHeaderView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISMainPageHeaderView.h"

@implementation ISMainPageHeaderView

- (void)awakeFromNib{
    self.deviceIdLabel.text = @"";
    self.deviceId.textColor = [UIColor darkGrayColor];
    self.remainTimeLabel.text = @"";
    self.remainTimeLabel.textColor = RGB(245, 132, 47);
    self.layer.borderColor = BorderColor;
    self.layer.borderWidth = 0.7;
    self.remainTimeBtn.backgroundColor = TheameColor;
}

@end
