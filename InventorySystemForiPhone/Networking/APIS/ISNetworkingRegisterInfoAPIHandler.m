//
//  ISNetworkingRegisterInfoAPIHandler.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingRegisterInfoAPIHandler.h"

@interface ISNetworkingRegisterInfoAPIHandler()<ISNetworkingAPIHandler,ISNetworkingAPIHandlerValidator>

@end

@implementation ISNetworkingRegisterInfoAPIHandler

#pragma mark - lifeCycle

- (instancetype)init{
    if (self = [super init]) {
        self.validator = self;
    }
    return self;
}


#pragma mark - ISNetworkingAPIHandler delegate

- (NSString*)methodName{
    return @"GetBCUSE";
}

- (NSString*)serviceType{
    return NSStringFromClass([ISNetworkingHostServiceProvider class]);
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
