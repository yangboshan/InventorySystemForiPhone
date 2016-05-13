//
//  BCPhotoAssetCameraCell.m
//  TripAway
//
//  Created by yangboshan on 16/3/10.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import "BCPhotoAssetCameraCell.h"

@implementation BCPhotoAssetCameraCell

- (void)awakeFromNib {
    self.cameraImageView.tintColor = [UIColor darkGrayColor];
    self.cameraImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.cameraImageView.image = [UIImage imageNamed:@"photopicker_camera"];
}

@end
