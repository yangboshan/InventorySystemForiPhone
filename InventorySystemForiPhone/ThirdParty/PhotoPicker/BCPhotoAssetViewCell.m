//
//  BCPhotoAssetViewCell.m
//  TripAway
//
//  Created by yangboshan on 16/3/8.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import "BCPhotoAssetViewCell.h"

@implementation BCPhotoAssetViewCell

- (void)awakeFromNib {
    self.assetImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.statusImageView.tag = 0;
    self.maskView.hidden = YES;
    self.maskView.backgroundColor = RGBA(0, 0, 0, 0.8);
}
 
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.statusImageView.image = [UIImage imageNamed:@"photopicker_checked"];
        self.maskView.hidden = NO;
        if (!self.statusImageView.tag) {
            self.statusImageView.layer.contents = (id)[UIImage imageNamed:@"photopicker_checked"].CGImage;
            self.statusImageView.tag = 1;
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.05),@(1.1),@(1.05),@(0.9),@(1.0)];
            k.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            k.duration = 0.5f;
            [self.statusImageView.layer addAnimation:k forKey:@"SHOW"];
        }        
    }else{
        self.maskView.hidden = YES;
        self.statusImageView.tag = 0;
        self.statusImageView.image = [UIImage imageNamed:@"photopicker_unchecked"];
    }
}

@end
