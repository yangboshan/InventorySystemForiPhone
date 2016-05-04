//
//  ISNetworkingProxy.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISNetworkingResponse;


typedef void(^ISNetworkingCallback)(ISNetworkingResponse *response);


@interface ISNetworkingProxy : NSObject

+ (instancetype)sharedInstance;

/**
 *  GET Request
 *
 *  @param params
 *  @param servieIdentifier
 *  @param methodName
 *  @param success
 *  @param fail
 *
 *  @return requestID
 */

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ISNetworkingCallback)success fail:(ISNetworkingCallback)fail;

/**
 *  POST Request
 *
 *  @param params
 *  @param servieIdentifier
 *  @param methodName
 *  @param success
 *  @param fail
 *
 *  @return requestID
 */
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ISNetworkingCallback)success fail:(ISNetworkingCallback)fail;

/**
 *  SOAP
 *
 *  @param params
 *  @param servieIdentifier
 *  @param methodName
 *  @param success
 *  @param fail
 *
 *  @return requestID
 */
- (NSInteger)callSOAPWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ISNetworkingCallback)success fail:(ISNetworkingCallback)fail;

/**
 *  Cancel Request By ID
 *
 *  @param requestID
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

/**
 *  cancel RequestList
 *
 *  @param requestIDList
 */
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
@end
