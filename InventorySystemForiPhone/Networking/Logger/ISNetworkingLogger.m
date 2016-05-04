//
//  ISNetworkingLogger.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingLogger.h"
#import "ISNetworkingBaseServiceProvider.h"
#import "NSObject+ISNetworking.h"
#import "ISNetworkingResponse.h"

@implementation ISNetworkingLogger


+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(ISNetworkingBaseServiceProvider *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod{
    
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    [logString appendFormat:@"API Name:\t\t%@\n", [apiName IS_defaultValue:@"N/A"]];
    [logString appendFormat:@"Method:\t\t\t%@\n", [httpMethod IS_defaultValue:@"N/A"]];
    [logString appendFormat:@"Version:\t\t%@\n", [service.serviceVersion IS_defaultValue:@"N/A"]];
    [logString appendFormat:@"Service:\t\t%@\n", [service class]];
    [logString appendFormat:@"Params:\n%@", requestParams];
    
    [logString appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [logString appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [logString appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] IS_defaultValue:@"\t\t\t\tN/A"]];
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
#endif
    
}

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error{
    
#ifdef DEBUG
    BOOL shouldLogError = error ? YES : NO;
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content:\n\t%@\n\n", responseString];
    
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    [logString appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [logString appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [logString appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] IS_defaultValue:@"\t\t\t\tN/A"]];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    
    NSLog(@"%@", logString);
#endif
    
}

+ (void)logDebugInfoWithCachedResponse:(ISNetworkingResponse *)response methodName:(NSString *)methodName serviceIdentifier:(ISNetworkingBaseServiceProvider *)service{
    
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n\n"];
    [logString appendFormat:@"API Name:\t\t%@\n", [methodName IS_defaultValue:@"N/A"]];
    [logString appendFormat:@"Version:\t\t%@\n", [service.serviceVersion IS_defaultValue:@"N/A"]];
    [logString appendFormat:@"Service:\t\t%@\n", [service class]];
    [logString appendFormat:@"Method Name:\t%@\n", methodName];
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    NSLog(@"%@", logString);
#endif
    
}

@end
