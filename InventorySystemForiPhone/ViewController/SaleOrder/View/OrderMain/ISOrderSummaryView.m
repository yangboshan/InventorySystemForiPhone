//
//  ISOrderSummaryView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/17.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderSummaryView.h"

@implementation ISOrderSummaryView

- (void)awakeFromNib{
    
    self.remarkTextField.font = LantingheiD(13);
    self.summaryLabel.font = LantingheiBoldD(14);
    self.summaryLabel.textColor = TheameColor;
    self.backgroundColor = [UIColor clearColor];
    self.checkBtn.tintColor = TheameColor;
}

- (IBAction)checkTapped:(id)sender {
    self.checkBtn.selected = ! self.checkBtn.selected;
}

@end
