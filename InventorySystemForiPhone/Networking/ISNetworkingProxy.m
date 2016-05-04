//
//  ISNetworkingProxy.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingProxy.h"
#import "ISNetworkingConfiguration.h"
#import "ISNetworkingServiceProviderFactory.h"
#import "NSURLRequest+ISNetworking.h"
#import "ISNetworkingLogger.h"
#import "ISNetworkingResponse.h"
#import "ISNetworkingRequestGenerator.h"
#import <AFNetworking/AFNetworking.h>

@interface ISNetworkingProxy()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@end

@implementation ISNetworkingProxy


#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPRequestOperationManager *)operationManager{
    if (_operationManager == nil) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _operationManager;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISNetworkingProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISNetworkingProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 


- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ISNetworkingCallback)success fail:(ISNetworkingCallback)fail
{
    NSURLRequest *request = [[ISNetworkingRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ISNetworkingCallback)success fail:(ISNetworkingCallback)fail{
    NSURLRequest *request = [[ISNetworkingRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callSOAPWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ISNetworkingCallback)success fail:(ISNetworkingCallback)fail{
    NSURLRequest *request = [[ISNetworkingRequestGenerator sharedInstance] generateSOAPRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSOperation *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(ISNetworkingCallback)success fail:(ISNetworkingCallback)fail{
    NSNumber *requestId = [self generateRequestId];
    
    AFHTTPRequestOperation *httpRequestOperation = [self.operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        [ISNetworkingLogger logDebugInfoWithResponse:operation.response
                              resposeString:operation.responseString
                                    request:operation.request
                                      error:NULL];
        
        ISNetworkingResponse *response = [[ISNetworkingResponse alloc] initWithResponseString:operation.responseString
                                                                        requestId:requestId
                                                                          request:operation.request
                                                                     responseData:operation.responseData
                                                                           status:ISURLResponseStatusSuccess];
        success?success(response):nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        [ISNetworkingLogger logDebugInfoWithResponse:operation.response
                              resposeString:operation.responseString
                                    request:operation.request
                                      error:error];
        
        ISNetworkingResponse *response = [[ISNetworkingResponse alloc] initWithResponseString:operation.responseString
                                                                        requestId:requestId
                                                                          request:operation.request
                                                                     responseData:operation.responseData
                                                                            error:error];
        fail?fail(response):nil;
        
    }];
    
    self.dispatchTable[requestId] = httpRequestOperation;
    [[self.operationManager operationQueue] addOperation:httpRequestOperation];
    return requestId;
}


- (NSNumber *)generateRequestId{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

@end
