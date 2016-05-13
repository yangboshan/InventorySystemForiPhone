//
//  BCPhotoAssetGroupCell.m
//  TripAway
//
//  Created by yangboshan on 16/3/9.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import "BCPhotoAssetGroupCell.h"

@implementation BCPhotoAssetGroupCell

- (void)awakeFromNib {
    
    self.groupImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.groupImageView.layer.cornerRadius = 3.0;
    self.groupImageView.clipsToBounds = YES;
    self.groupLabel.font = LantingheiBold(15);
    self.contentView.backgroundColor = RGB(240, 240, 240);
}


@end
