//
//  ISQueryOrderHeaderView.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/20.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ISQueryOrderHeaderViewRefreshBlock)(id obj);

@interface ISQueryOrderHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *customBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, copy) ISQueryOrderHeaderViewRefreshBlock block;
@end
