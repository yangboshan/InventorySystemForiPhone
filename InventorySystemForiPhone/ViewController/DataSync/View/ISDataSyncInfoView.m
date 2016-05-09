//
//  ISDataSyncView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/9.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISDataSyncInfoView.h"

@interface ISDataSyncInfoView()
@end

@implementation ISDataSyncInfoView

- (void)awakeFromNib{
    [self.filledIndicator setBackgroundColor:[UIColor whiteColor]];
    [self.filledIndicator setFillColor:TheameColor];
    [self.filledIndicator setStrokeColor:TheameColor];
    [self.filledIndicator setRadiusPercent:0.45];
    [self.filledIndicator loadIndicator];
    self.lastUpdateLabel.text = [NSString stringWithFormat:@"上次同步成功时间: %@",[[ISSettingManager sharedInstance].lastSyncDate dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
}

- (void)setProgress:(float)progress{
    _progress = progress;
    [self.filledIndicator updateWithTotalBytes:100 downloadedBytes:progress*100];
}

@end
