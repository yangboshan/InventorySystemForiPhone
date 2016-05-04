//
//  ISNetworkingBaseAPIHandler.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISNetworkingSOAPServiceProvider.h"

@class ISNetworkingBaseAPIHandler;
@class ISNetworkingResponse;

static NSString * const kISNetworkingAPIHandlerRequestID = @"kISNetworkingAPIHandlerRequestID";


/**
 *  CallBack Delegate
 */
@protocol ISNetworkingAPIHandlerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager;
- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager;
@end

/**
 *  Data Formatter
 */
@protocol ISNetworkingAPIHandlerCallBackReformer <NSObject>
@required
- (id)manager:(ISNetworkingBaseAPIHandler *)manager reformData:(id)data;
@end


/**
 *  Validator
 */
@protocol ISNetworkingAPIHandlerValidator <NSObject>
@required
- (BOOL)manager:(ISNetworkingBaseAPIHandler *)manager isCorrectWithCallBackData:(NSDictionary *)data;
- (BOOL)manager:(ISNetworkingBaseAPIHandler *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end

/**
 *  ParamSource
 */
@protocol ISNetworkingAPIHandlerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForApi:(ISNetworkingBaseAPIHandler *)manager;
@end


typedef NS_ENUM (NSUInteger, ISNetworkingAPIHandlerStatusType){
    ISNetworkingAPIHandlerStatusTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    ISNetworkingAPIHandlerStatusTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    ISNetworkingAPIHandlerStatusTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    ISNetworkingAPIHandlerStatusTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    ISNetworkingAPIHandlerStatusTypeTimeout,       //请求超时。Proxy设置的是20秒超时，具体超时时间的设置请自己去看Proxy的相关代码。
    ISNetworkingAPIHandlerStatusTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, ISNetworkingAPIHandlerRequestType){
    ISNetworkingAPIHandlerRequestTypeGet,
    ISNetworkingAPIHandlerRequestTypePost,
    ISNetworkingAPIHandlerRequestTypeSOAP
};


/**
 *  子类需要实现的方法
 */
@protocol ISNetworkingAPIHandler <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (ISNetworkingAPIHandlerRequestType)requestType;

@optional

- (void)cleanData;
- (BOOL)shouldCache;

- (NSDictionary *)reformParams:(NSDictionary *)params;

@end

/**
 *  拦截器
 */
@protocol ISNetworkingAPIHandlerInterceptor <NSObject>

@optional
- (void)manager:(ISNetworkingBaseAPIHandler *)manager beforePerformSuccessWithResponse:(ISNetworkingResponse *)response;
- (void)manager:(ISNetworkingBaseAPIHandler *)manager afterPerformSuccessWithResponse:(ISNetworkingResponse *)response;

- (void)manager:(ISNetworkingBaseAPIHandler *)manager beforePerformFailWithResponse:(ISNetworkingResponse *)response;
- (void)manager:(ISNetworkingBaseAPIHandler *)manager afterPerformFailWithResponse:(ISNetworkingResponse *)response;

- (BOOL)manager:(ISNetworkingBaseAPIHandler *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(ISNetworkingBaseAPIHandler *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end


@interface ISNetworkingBaseAPIHandler : NSObject

@property (nonatomic, weak) id<ISNetworkingAPIHandlerCallBackDelegate> delegate;
@property (nonatomic, weak) id<ISNetworkingAPIHandlerParamSourceDelegate> paramSource;
@property (nonatomic, weak) id<ISNetworkingAPIHandlerValidator> validator;
@property (nonatomic, weak) NSObject<ISNetworkingAPIHandler> *child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id<ISNetworkingAPIHandlerInterceptor> interceptor;


@property (nonatomic, strong, readonly) id fetchedRawData;
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) ISNetworkingAPIHandlerStatusType errorType;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;


- (id)fetchDataWithReformer:(id<ISNetworkingAPIHandlerCallBackReformer>)reformer;

- (NSInteger)loadData;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;


- (void)beforePerformSuccessWithResponse:(ISNetworkingResponse *)response;
- (void)afterPerformSuccessWithResponse:(ISNetworkingResponse *)response;

- (void)beforePerformFailWithResponse:(ISNetworkingResponse *)response;
- (void)afterPerformFailWithResponse:(ISNetworkingResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;


- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;

@end
