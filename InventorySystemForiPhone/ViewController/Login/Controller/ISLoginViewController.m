//
//  ISLoginViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISLoginViewController.h"
#import "ISLoginViewModel.h"


#import "ISNetworkingLoginAPIHandler.h"
#import "ISNetworkingPrivilegeAPIHandler.h"
#import "ISLoginResutFormatter.h"
#import "ISLoginPrivilegeFormatter.h"
#import "NSObject+ISNetworking.h"

#import "ISLoginBoardView.h"

@interface ISLoginViewController()<ISNetworkingAPIHandlerCallBackDelegate,ISNetworkingAPIHandlerParamSourceDelegate>

@property (nonatomic,strong) ISNetworkingLoginAPIHandler * loginAPIHandler;
@property (nonatomic,strong) ISNetworkingPrivilegeAPIHandler * privilegeAPIHandler;

@property (nonatomic,strong) ISLoginResutFormatter * loginResultFormatter;
@property (nonatomic,strong) ISLoginPrivilegeFormatter * loginPrivilegeFormatter;

@property (nonatomic,strong) ISLoginBoardView* loginBoardView;
@property (nonatomic,strong) ISLoginViewModel* loginViewModel;
@end

@implementation ISLoginViewController


#pragma mark -  lifeCycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialSetup];
}


- (void)initialSetup{
    [self.view setBackgroundColor:RGB(243, 244, 245)];
    [self.view addSubview:self.loginBoardView];
    [self autolayoutBoardView];
}

- (void)autolayoutBoardView{
    [self.loginBoardView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(NavBarHeight, 0, 0, 0)];
}

#pragma mark - event

- (void)login:(UIButton*)sender{
    if ([self.loginViewModel checkLoginInfoByUserName:self.loginBoardView.userNameTextField.text userPsw:self.loginBoardView.pswTextField.text]) {
        [[ISProcessViewHelper sharedInstance] showProcessViewInView:self.view];
        [self.loginAPIHandler loadData];
    }else{
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"请输入完整信息" InView:self.view];
    }
}


#pragma mark - ISNetworkingAPIHandlerCallBackDelegate

- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager{
    
    if ([manager isKindOfClass:[ISNetworkingLoginAPIHandler class]]) {
        NSDictionary* data = [self.loginResultFormatter manager:manager reformData:manager.fetchedRawData];
        if (![data[kISLoginResut] IS_isEmptyObject]) {
            [ISSettingManager sharedInstance].currentUser = [@{@"userId":self.loginBoardView.userNameTextField.text,
                                                              @"psw":self.loginBoardView.pswTextField.text,
                                                              @"userName":data[kISLoginResut]} mutableCopy];
            [self.privilegeAPIHandler loadData];
        }else{
            [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"用户名或密码错误" InView:self.view];
        }
    }
    
    if ([manager isKindOfClass:[ISNetworkingPrivilegeAPIHandler class]]) {
        
        NSDictionary* data = [self.loginPrivilegeFormatter manager:manager reformData:manager.fetchedRawData];
        NSMutableDictionary* currentUser = [[ISSettingManager sharedInstance].currentUser mutableCopy];
        [currentUser setValue:data[@"privilege"] forKey:@"privilege"];
        
        [ISSettingManager sharedInstance].currentUser = currentUser;
        [ISSettingManager sharedInstance].logined = YES;

        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"登录成功" InView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:kISLoginDidSuccessNotification object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager{
    [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"ERROR" InView:self.view];
}

#pragma mark - ISNetworkingAPIHandlerParamSourceDelegate

- (NSDictionary*)paramsForApi:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingLoginAPIHandler class]]) {
        return @{@"sUserName":self.loginBoardView.userNameTextField.text,@"sPsw":self.loginBoardView.pswTextField.text};
    }
    if ([manager isKindOfClass:[ISNetworkingPrivilegeAPIHandler class]]) {
        return @{@"sUserId":self.loginBoardView.userNameTextField.text};
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

- (ISLoginPrivilegeFormatter*)loginPrivilegeFormatter{
    if (_loginPrivilegeFormatter == nil) {
        _loginPrivilegeFormatter = [ISLoginPrivilegeFormatter new];
    }
    return _loginPrivilegeFormatter;
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
        [_loginBoardView.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBoardView;
}

- (ISLoginViewModel*)loginViewModel{
    if (_loginViewModel == nil) {
        _loginViewModel = [ISLoginViewModel new];
    }
    return _loginViewModel;
}

@end
