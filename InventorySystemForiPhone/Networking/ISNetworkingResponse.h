//
//  ISNetworkingResponse.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISNetworkingConfiguration.h"

@interface ISNetworkingResponse : NSObject

@property (nonatomic, assign, readonly) ISURLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign, readonly) BOOL isCache;

/**
 *
 *
 *  @param responseString
 *  @param requestId
 *  @param request
 *  @param responseData
 *  @param status
 *
 *  @return
 */
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(ISURLResponseStatus)status;

/**
 *
 *
 *  @param responseString
 *  @param requestId
 *  @param request
 *  @param responseData
 *  @param error
 *
 *  @return
 */
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;

/**
 *  使用initWithData的response，它的isCache是YES，上面两个函数生成的response的isCache是NO
 *
 *  @param data
 *
 *  @return
 */
- (instancetype)initWithData:(NSData *)data;

@end
