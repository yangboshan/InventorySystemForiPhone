//
//  BCPhotoAssetViewCell.h
//  TripAway
//
//  Created by yangboshan on 16/3/8.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPhotoAssetViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *assetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@end
