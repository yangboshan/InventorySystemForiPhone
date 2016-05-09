//
//  ISDataSyncViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/6.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISDataSyncViewController.h"
#import "ISDataSyncModel.h"
#import "ISDataSyncInfoView.h"

@interface ISDataSyncViewController ()
@property (nonatomic,strong) ISDataSyncInfoView * syncView;
@end

@implementation ISDataSyncViewController

#pragma mark - life Cycle

- (void)dealloc{
    [[ISDataSyncModel sharedInstance] removeObserver:self forKeyPath:@"progress" context:nil];
    [[ISDataSyncModel sharedInstance] removeObserver:self forKeyPath:@"status" context:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialSetup];
    [[ISDataSyncModel sharedInstance] startSync];
}


- (void)initialSetup{
    [self.view setBackgroundColor:RGB(243, 244, 245)];
    [self.view addSubview:self.syncView];
    [self autolayoutSubView];
    
    [[ISDataSyncModel sharedInstance] addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [[ISDataSyncModel sharedInstance] addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];

}

- (void)autolayoutSubView{
    [self.syncView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(NavBarHeight, 0, 0, 0)];
}

#pragma mark -  observeValueForKeyPath

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"progress"]) {
        float progress = [change[@"new"] floatValue];
        self.syncView.progress = progress;
    }
    if ([keyPath isEqualToString:@"status"]) {
        
        ISDataSyncStatus status = [change[@"new"] integerValue];
        switch (status) {
            case ISDataSyncStatusDefault:
                self.syncView.statusLabel.text = @"";
                self.syncView.syncBtn.enabled = NO;
                
                break;
            case ISDataSyncStatusFinished:
                self.syncView.statusLabel.text = @"同步完成";
                self.syncView.syncBtn.enabled = YES;

                break;
            case ISDataSyncStatusSyncing:
                self.syncView.statusLabel.text = @"正在同步";
                self.syncView.syncBtn.enabled = NO;
                
                break;
            case ISDataSyncStatusError:
                self.syncView.statusLabel.text = @"同步出错";
                self.syncView.syncBtn.enabled = YES;

                break;
            default:
                break;
        }
    }
}

#pragma mark - event

- (void)syncImmediately:(id)sender{
    [[ISDataSyncModel sharedInstance] startSync];
}


#pragma mark - property

- (ISDataSyncInfoView*)syncView{
    if (_syncView == nil) {
        _syncView = [[[NSBundle mainBundle] loadNibNamed:@"ISDataSyncInfoView" owner:nil options:nil] lastObject];
        [_syncView.syncBtn addTarget:self action:@selector(syncImmediately:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _syncView;
}

@end
