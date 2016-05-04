//
//  NSURLRequest+ISNetworking.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "NSURLRequest+ISNetworking.h"
#import <objc/runtime.h>


static void *ISNetworkingRequestParams;


@implementation NSURLRequest (ISNetworking)

- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, &ISNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams{
    return objc_getAssociatedObject(self, &ISNetworkingRequestParams);
}

@end
