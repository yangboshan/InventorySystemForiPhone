//
//  ISMainPageHeaderView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISMainPageHeaderView.h"
#import "ISDataSyncModel.h"

@implementation ISMainPageHeaderView


- (void)dealloc{
    [[ISDataSyncModel sharedInstance] removeObserver:self forKeyPath:@"progress" context:nil];
    [[ISDataSyncModel sharedInstance] removeObserver:self forKeyPath:@"status" context:nil];
    [[ISSettingManager sharedInstance] removeObserver:self forKeyPath:@"lastSyncDate" context:nil];
}

- (void)awakeFromNib{
    
    self.deviceIdLabel.text = @"";
    self.deviceId.textColor = [UIColor lightGrayColor];
    self.remainTimeLabel.text = @"";
    self.remainTimeLabel.textColor = TheameColor;
    self.bgView.layer.borderColor = BorderColor;
    self.bgView.layer.borderWidth = 0.7;
    self.remainTimeBtn.backgroundColor = TheameColor;
    self.userNameLabel.text = [ISSettingManager sharedInstance].currentUser[@"userName"];
    self.lastSyncDate.hidden = YES;
    self.deviceId.text = [[ISSettingManager sharedInstance].deviceId uppercaseString];
    
    [[ISDataSyncModel sharedInstance] addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [[ISDataSyncModel sharedInstance] addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [[ISSettingManager sharedInstance] addObserver:self forKeyPath:@"lastSyncDate" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"progress"]) {
        float progress = [change[@"new"] floatValue];
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
    }
    
    if ([keyPath isEqualToString:@"lastSyncDate"]) {
        if ([ISSettingManager sharedInstance].lastSyncDate) {
            self.lastSyncDate.text = [NSString stringWithFormat:@"上次同步: %@",[[ISSettingManager sharedInstance].lastSyncDate dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
        }else{
            self.lastSyncDate.text  = @"上次同步: 从未同步";
        }
    }
    
    if ([keyPath isEqualToString:@"status"]) {
        self.statusLabel.text = [ISDataSyncModel sharedInstance].statusDescription;
    }
}

@end
