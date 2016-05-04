//
//  ISNetworkingRequestGenerator.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISNetworkingRequestGenerator : NSObject

+ (instancetype)sharedInstance;

/**
 *  generate GET Request
 *
 *  @param serviceIdentifier
 *  @param requestParams
 *  @param methodName
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

/**
 *  generate POST Request
 *
 *  @param serviceIdentifier
 *  @param requestParams
 *  @param methodName
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;


/**
 *  generate SOAP Request
 *
 *  @param serviceIdentifier
 *  @param requestParams
 *  @param methodName
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)generateSOAPRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;


@end
