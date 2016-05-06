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
    self.remainTimeLabel.text = @"";
    self.remainTimeLabel.textColor = [UIColor greenColor];
    self.layer.borderColor = BorderColor;
    self.layer.borderWidth = 0.7;
}

@end
