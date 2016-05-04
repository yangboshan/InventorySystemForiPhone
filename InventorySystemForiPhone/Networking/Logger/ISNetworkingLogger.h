//
//  ISNetworkingLogger.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISNetworkingBaseServiceProvider;
@class ISNetworkingResponse;


@interface ISNetworkingLogger : NSObject

/**
 *  Log request info when in debug mode
 *
 *  @param request
 *  @param apiName
 *  @param service
 *  @param requestParams
 *  @param httpMethod
 */
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(ISNetworkingBaseServiceProvider *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;

/**
 *  Log response info when in debug mode
 *
 *  @param response
 *  @param responseString
 *  @param request
 *  @param error
 */
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

/**
 *  Log cache response info when in debug mode
 *
 *  @param response
 *  @param methodName
 *  @param service
 */
+ (void)logDebugInfoWithCachedResponse:(ISNetworkingResponse *)response methodName:(NSString *)methodName serviceIdentifier:(ISNetworkingBaseServiceProvider *)service;


@end
