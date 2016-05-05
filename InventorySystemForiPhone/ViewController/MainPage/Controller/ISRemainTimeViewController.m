//
//  ISRemainTimeViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISRemainTimeViewController.h"
#import "ISNetworkingRegisterInfoAPIHandler.h"
#import "ISRemainTimeFormatter.h"

@interface ISRemainTimeViewController ()<ISNetworkingAPIHandlerCallBackDelegate,ISNetworkingAPIHandlerParamSourceDelegate>
@property (nonatomic,strong) ISNetworkingRegisterInfoAPIHandler* registerInfoAPIHandler;
@property (nonatomic,strong) ISRemainTimeFormatter * remainTimeFormatter;

@end

@implementation ISRemainTimeViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    [self.view setBackgroundColor:RGB(243, 244, 245)];
    [self.registerInfoAPIHandler loadData];
}


#pragma mark - ISNetworkingAPIHandlerCallBackDelegate

- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingRegisterInfoAPIHandler class]]) {
        NSDictionary* data = [self.remainTimeFormatter manager:manager reformData:manager.fetchedRawData];
        NSLog(@"%@",data);
    }
}

- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager{
    [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"ERROR" InView:self.view];
}

#pragma mark - ISNetworkingAPIHandlerParamSourceDelegate

- (NSDictionary*)paramsForApi:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingRegisterInfoAPIHandler class]]) {
        return @{@"HashID":[[UIDevice currentDevice] IS_macaddressMD5]};
    }
    return nil;
}

#pragma mark - property

- (ISNetworkingRegisterInfoAPIHandler*)registerInfoAPIHandler{
    if (_registerInfoAPIHandler == nil) {
        _registerInfoAPIHandler = [[ISNetworkingRegisterInfoAPIHandler alloc] init];
        _registerInfoAPIHandler.paramSource = self;
        _registerInfoAPIHandler.delegate = self;
    }
    return _registerInfoAPIHandler;
}

- (ISRemainTimeFormatter*)remainTimeFormatter{
    if (!_remainTimeFormatter) {
        _remainTimeFormatter = [ISRemainTimeFormatter new];
    }
    return _remainTimeFormatter;
}


@end
