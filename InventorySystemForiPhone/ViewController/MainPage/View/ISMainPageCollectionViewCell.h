//
//  ISMainPageCollectionViewCell.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISMainPageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic,strong) NSDictionary* data;

@end
