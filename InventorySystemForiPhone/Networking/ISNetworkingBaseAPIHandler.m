//
//  ISNetworkingBaseAPIHandler.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingBaseAPIHandler.h"
#import "ISNetworking.h"
#import "ISNetworkingBaseServiceProvider.h"
#import "ISNetworkingServiceProviderFactory.h"

#import <AFNetworking/AFNetworking.h>


#define AXCallAPI(REQUEST_METHOD, REQUEST_ID)                                                       \
{                                                                                       \
REQUEST_ID = [[ISNetworkingProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(ISNetworkingResponse *response) { \
[self successedOnCallingAPI:response];                                          \
} fail:^(ISNetworkingResponse *response) {                                                \
[self failedOnCallingAPI:response withErrorType:ISNetworkingAPIHandlerStatusTypeDefault];  \
}];                                                                                 \
[self.requestIdList addObject:@(REQUEST_ID)];                                          \
}



@interface ISNetworkingBaseAPIHandler()

@property (nonatomic, strong, readwrite) id fetchedRawData;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) ISNetworkingAPIHandlerStatusType statusType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) ISNetworkingCache *cache;

@end

@implementation ISNetworkingBaseAPIHandler

#pragma mark - life cycle

- (instancetype)init{
    
    if (self = [super init]) {
        
        if ([self conformsToProtocol:@protocol(ISNetworkingAPIHandler)]) {
            self.child = (id <ISNetworkingAPIHandler>)self;
        }else{
            NSAssert(NO, @"");
        }
        
        _errorMessage = nil;
        _errorType = ISNetworkingAPIHandlerStatusTypeDefault;
        
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        _fetchedRawData = nil;
    }
    return self;
}

- (void)dealloc{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - API call

- (NSInteger)loadData{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params{
    
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
                return 0;
            }
            
            // 实际的网络请求
            if ([self isReachable]) {
                switch (self.child.requestType){
                    case ISNetworkingAPIHandlerRequestTypeGet:
                        AXCallAPI(GET, requestId);
                        break;
                    case ISNetworkingAPIHandlerRequestTypePost:
                        AXCallAPI(POST, requestId);
                        break;
                    case ISNetworkingAPIHandlerRequestTypeSOAP:
                        AXCallAPI(SOAP, requestId);
                        break;
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kISNetworkingAPIHandlerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:ISNetworkingAPIHandlerStatusTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:ISNetworkingAPIHandlerStatusTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params{
    
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ISNetworkingResponse *response = [[ISNetworkingResponse alloc] initWithData:result];
        response.requestParams = params;
        [ISNetworkingLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[ISNetworkingServiceProviderFactory sharedInstance] serviceProviderByIdentifier:serviceIdentifier]];
        [self successedOnCallingAPI:response];
    });
    return YES;
}


- (void)successedOnCallingAPI:(ISNetworkingResponse *)response{
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }
        
        [self beforePerformSuccessWithResponse:response];
        [self.delegate managerCallAPIDidSuccess:self];
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:ISNetworkingAPIHandlerStatusTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(ISNetworkingResponse *)response withErrorType:(ISNetworkingAPIHandlerStatusType)statusType{
    self.statusType = statusType;
    [self removeRequestIdWithRequestID:response.requestId];
    [self beforePerformFailWithResponse:response];
    [self.delegate managerCallAPIDidFailed:self];
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor

- (void)beforePerformSuccessWithResponse:(ISNetworkingResponse *)response{
    self.statusType = ISNetworkingAPIHandlerStatusTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
}

- (void)afterPerformSuccessWithResponse:(ISNetworkingResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (void)beforePerformFailWithResponse:(ISNetworkingResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
}

- (void)afterPerformFailWithResponse:(ISNetworkingResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark -

- (void)cleanData{
    IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
    IMP selfIMP = [self methodForSelector:@selector(cleanData)];
    
    if (childIMP == selfIMP) {
        self.fetchedRawData = nil;
        self.errorMessage = nil;
        self.statusType = ISNetworkingAPIHandlerStatusTypeDefault;
    } else {
        if ([self.child respondsToSelector:@selector(cleanData)]) {
            [self.child cleanData];
        }
    }
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了

- (NSDictionary *)reformParams:(NSDictionary *)params{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

#pragma mark -

- (BOOL)shouldCache{
    return kISShouldCache;
}

- (void)cancelAllRequests{
    [[ISNetworkingProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID{
    [self removeRequestIdWithRequestID:requestID];
    [[ISNetworkingProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (id)fetchDataWithReformer:(id<ISNetworkingAPIHandlerCallBackReformer>)reformer{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}


#pragma mark property

- (ISNetworkingCache *)cache{
    if (_cache == nil) {
        _cache = [ISNetworkingCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable{
    BOOL isReachability = [ISNetworkingContext sharedInstance].isReachable;
    if (!isReachability) {
        self.statusType = ISNetworkingAPIHandlerStatusTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading{
    return [self.requestIdList count] > 0;
}


@end
