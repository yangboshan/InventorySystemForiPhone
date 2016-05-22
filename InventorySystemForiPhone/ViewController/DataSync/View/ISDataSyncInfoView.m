//
//  ISDataSyncView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/9.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISDataSyncInfoView.h"
#import "ISDataSyncModel.h"

@interface ISDataSyncInfoView()
@end

@implementation ISDataSyncInfoView

- (void)awakeFromNib{
    
    [self.filledIndicator setBackgroundColor:[UIColor whiteColor]];
    [self.filledIndicator setFillColor:TheameColor];
    [self.filledIndicator setStrokeColor:TheameColor];
    [self.filledIndicator setRadiusPercent:0.45];
    [self.filledIndicator loadIndicator];
    [self.syncBtn setTitleColor:TheameColor forState:UIControlStateNormal];

    self.lastUpdateLabel.textColor = [UIColor grayColor];
    self.statusLabel.textColor = TheameColor;
    self.progressLabel.textColor = TheameColor;
    self.progressLabel.text = @"";
    
    self.statusLabel.font = LantingheiBoldD(15);
    self.progressLabel.font = LantingheiBoldD(15);
}

- (void)setProgress:(float)progress{
    _progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
    [self.filledIndicator updateWithTotalBytes:100 downloadedBytes:progress*100];
}



@end
