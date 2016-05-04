//
//  ISNetworkingRequestGenerator.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingRequestGenerator.h"
#import "ISNetworkingConfiguration.h"
#import "ISNetworkingSOAPServiceProvider.h"
#import "ISNetworkingBaseServiceProvider.h"
#import "ISNetworkingServiceProviderFactory.h"
#import "ISNetworkingLogger.h"
#import "NSURLRequest+ISNetworking.h"


#import <AFNetworking/AFNetworking.h>


@interface ISNetworkingRequestGenerator()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation ISNetworkingRequestGenerator

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kISNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

#pragma mark - public methods
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISNetworkingRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISNetworkingRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    ISNetworkingBaseServiceProvider *service = [[ISNetworkingServiceProviderFactory sharedInstance] serviceProviderByIdentifier:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", service.serviceUrl,methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.timeoutInterval = kISNetworkingTimeoutSeconds;
    request.requestParams = requestParams;
    [ISNetworkingLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"GET"];
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    ISNetworkingBaseServiceProvider *service = [[ISNetworkingServiceProviderFactory sharedInstance] serviceProviderByIdentifier:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", service.serviceUrl,methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.timeoutInterval = kISNetworkingTimeoutSeconds;
    request.requestParams = requestParams;
    [ISNetworkingLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"POST"];
    return request;
}

- (NSURLRequest *)generateSOAPRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    
    ISNetworkingBaseServiceProvider *service = [[ISNetworkingServiceProviderFactory sharedInstance] serviceProviderByIdentifier:serviceIdentifier];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:service.serviceUrl parameters:nil error:NULL];
    NSString* soapMsg = [self generateSOAPMsgByParams:requestParams methodName:methodName];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMsg length]];
    
    [request addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (NSString*)generateSOAPMsgByParams:(NSDictionary*)params methodName:(NSString*)methodName{
    
    NSMutableString* soapMsg = [NSMutableString string];
    [soapMsg appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    [soapMsg appendString:@"<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"];
    [soapMsg appendString:@"<soap12:Body>"];
    [soapMsg appendString:[NSString stringWithFormat:@"<%@ xmlns=\"http://tempuri.org/\">",methodName]];
    for(NSString* field in params.allKeys){
        [soapMsg appendString:[NSString stringWithFormat:@"<%@>%@</%@>",field,params[field],field]];
    }
    [soapMsg appendString:[NSString stringWithFormat:@"</%@>",methodName]];
    [soapMsg appendString:@"</soap12:Body>"];
    [soapMsg appendString:@"</soap12:Envelope>"];

    return soapMsg;
}


@end
