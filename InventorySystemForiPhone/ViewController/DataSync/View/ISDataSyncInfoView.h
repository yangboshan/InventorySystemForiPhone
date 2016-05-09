//
//  ISDataSyncView.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/9.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDownloadIndicator.h"

@interface ISDataSyncInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet RMDownloadIndicator *filledIndicator;
@property (weak, nonatomic) IBOutlet UIButton *syncBtn;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic, assign) float progress;

@end
