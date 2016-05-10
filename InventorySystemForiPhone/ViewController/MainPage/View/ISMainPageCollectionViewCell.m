//
//  ISMainPageCollectionViewCell.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISMainPageCollectionViewCell.h"

@implementation ISMainPageCollectionViewCell

- (void)awakeFromNib {
    self.containerView.layer.cornerRadius = 5;
    self.containerView.clipsToBounds = YES;
    self.infoLabel.font = LantingheiBold(14);
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    
    if ([data[@"bg"] isKindOfClass:[UIColor class]]) {
        self.containerView.backgroundColor = data[@"bg"];
    }
    
    self.infoLabel.text = data[@"desc"];
    self.infoImageView.image = [UIImage imageNamed:data[@"icon"]];
    self.infoImageView.tintColor = [UIColor whiteColor];
}

@end
