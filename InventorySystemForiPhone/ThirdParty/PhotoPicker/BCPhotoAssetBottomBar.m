//
//  BCPhotoAssetBottomBar.m
//  TripAway
//
//  Created by yangboshan on 16/3/9.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import "BCPhotoAssetBottomBar.h"

@implementation BCPhotoAssetBottomBar

- (void)awakeFromNib{
    
    self.previewBtn.titleLabel.font = LantingheiBold(15);
    self.finishBtn.titleLabel.font = LantingheiBold(15);
    [self.previewBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.previewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.finishBtn setTitleColor:TheameColor forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.countLabel.backgroundColor = TheameColor;
    self.countLabel.font = LantingheiBoldS(14);
    self.countLabel.layer.cornerRadius = 9;
    self.countLabel.clipsToBounds = YES;
    self.countLabel.hidden = YES;

    self.layer.borderColor = BorderColor;
    self.layer.borderWidth = 0.7;
    
    self.previewBtn.enabled = NO;
    self.finishBtn.enabled = NO;
}

- (void)updateStatus:(NSArray *)list{
    if (list.count) {
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"%d",(int)[list count]];
        self.previewBtn.enabled = YES;
        self.finishBtn.enabled = YES;
        
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.05),@(1.1),@(1.05),@(0.9),@(1.0)];
        k.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        k.duration = 0.5f;
        [self.countLabel.layer addAnimation:k forKey:@"SHOW"];
        
    }else{
        self.countLabel.hidden = YES;
        self.previewBtn.enabled = NO;
        self.finishBtn.enabled = NO;
    }
}

@end
