//
//  ISNetworkingUploadOrderAPIHandler.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/18.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingUploadOrderAPIHandler.h"

@interface ISNetworkingUploadOrderAPIHandler()<ISNetworkingAPIHandler,ISNetworkingAPIHandlerValidator>

@end

@implementation ISNetworkingUploadOrderAPIHandler

#pragma mark - lifeCycle

- (instancetype)init{
    if (self = [super init]) {
        self.validator = self;
    }
    return self;
}

#pragma mark - ISNetworkingAPIHandler delegate

- (NSString*)methodName{
    return @"Upd_SwapBill_FA";
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
