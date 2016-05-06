//
//  ISMainPageHeaderView.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISMainPageHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *deviceId;
@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *remainTimeBtn;
@end
