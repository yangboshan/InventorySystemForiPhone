//
//  ISLoginViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISLoginViewController.h"
#import "ISCommonMacro.h"

#import "ISNetworkingLoginAPIHandler.h"
#import "ISNetworkingPrivilegeAPIHandler.h"
#import "ISLoginResutFormatter.h"
#import "NSObject+ISNetworking.h"

#import "ISLoginBoardView.h"

@interface ISLoginViewController()<ISNetworkingAPIHandlerCallBackDelegate,ISNetworkingAPIHandlerParamSourceDelegate>
@property (nonatomic,strong) ISNetworkingLoginAPIHandler * loginAPIHandler;
@property (nonatomic,strong) ISNetworkingPrivilegeAPIHandler * privilegeAPIHandler;
@property (nonatomic,strong) ISLoginResutFormatter * loginResultFormatter;
@property (nonatomic,strong) ISLoginBoardView* loginBoardView;
@end

@implementation ISLoginViewController


#pragma mark -  lifeCycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialSetup];
}


- (void)initialSetup{
    self.view.backgroundColor = RGB(243, 244, 245);
    [self.view addSubview:self.loginBoardView];
    [self.loginAPIHandler loadData];
}

#pragma mark - ISNetworkingAPIHandlerCallBackDelegate

- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager{
    
    if ([manager isKindOfClass:[ISNetworkingLoginAPIHandler class]]) {
        NSDictionary* data = [self.loginResultFormatter manager:manager reformData:manager.fetchedRawData];
        if (![data[kISLoginResut] IS_isEmptyObject]) {
            [self.privilegeAPIHandler loadData];
        }
    }
    
    if ([manager isKindOfClass:[ISNetworkingPrivilegeAPIHandler class]]) {
        NSLog(@"a");
    }
}

- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager{
    NSLog(@"fail");
}

#pragma mark - ISNetworkingAPIHandlerParamSourceDelegate

- (NSDictionary*)paramsForApi:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingLoginAPIHandler class]]) {
        return @{@"sUserName":@"3",@"sPsw":@"3"};
    }
    if ([manager isKindOfClass:[ISNetworkingPrivilegeAPIHandler class]]) {
        return @{@"sUserId":@"3"};
    }
    return nil;
}

#pragma mark - property

- (ISLoginResutFormatter*)loginResultFormatter{
    if (_loginResultFormatter == nil) {
        _loginResultFormatter = [ISLoginResutFormatter new];
    }
    return _loginResultFormatter;
}

- (ISNetworkingBaseAPIHandler*)loginAPIHandler{
    if (_loginAPIHandler == nil) {
        _loginAPIHandler = [ISNetworkingLoginAPIHandler new];
        _loginAPIHandler.delegate = self;
        _loginAPIHandler.paramSource = self;
    }
    return _loginAPIHandler;
}

- (ISNetworkingPrivilegeAPIHandler*)privilegeAPIHandler{
    if (_privilegeAPIHandler == nil) {
        _privilegeAPIHandler = [ISNetworkingPrivilegeAPIHandler new];
        _privilegeAPIHandler.delegate = self;
        _privilegeAPIHandler.paramSource = self;
    }
    return _privilegeAPIHandler;
}

- (ISLoginBoardView*)loginBoardView{
    if (_loginBoardView == nil) {
        _loginBoardView = [[[NSBundle mainBundle] loadNibNamed:@"ISLoginBoardView" owner:nil options:nil] firstObject];
    }
    return _loginBoardView;
}

@end
