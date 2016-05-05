//
//  ISLoginView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISLoginBoardView.h"

@implementation ISLoginBoardView

- (void)awakeFromNib{
    self.containerView.layer.borderColor = BorderColor;
    self.containerView.layer.borderWidth = 0.7;
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.backgroundColor = TheameColor;
}

@end
