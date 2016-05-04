//
//  ISNetworkingPrivilegeAPIHandler.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingPrivilegeAPIHandler.h"

@interface ISNetworkingPrivilegeAPIHandler()<ISNetworkingAPIHandler,ISNetworkingAPIHandlerValidator>

@end

@implementation ISNetworkingPrivilegeAPIHandler

#pragma mark - lifeCycle

- (instancetype)init{
    if (self = [super init]) {
        self.validator = self;
    }
    return self;
}


#pragma mark - ISNetworkingAPIHandler delegate

- (NSString*)methodName{
    return @"GetPower";
}

- (NSString*)serviceType{
    return NSStringFromClass([ISNetworkingSOAPServiceProvider class]);
}

- (ISNetworkingAPIHandlerRequestType)requestType{
    return ISNetworkingAPIHandlerRequestTypeSOAP;
}

#pragma mark - ISNetworkingAPIHandlerValidator
- (BOOL)manager:(ISNetworkingBaseAPIHandler *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}

- (BOOL)manager:(ISNetworkingBaseAPIHandler *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    return YES;
}

@end
