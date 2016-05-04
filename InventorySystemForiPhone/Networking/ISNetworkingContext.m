//
//  ISNetworkingContext.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingContext.h"
#import "AFNetworkReachabilityManager.h"
#import "NSObject+ISNetworking.h"
#import <UIKit/UIkit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ISNetworkingContext()

@property (nonatomic, strong) UIDevice *device;

@property (nonatomic, copy, readwrite) NSString *m;
@property (nonatomic, copy, readwrite) NSString *o;
@property (nonatomic, copy, readwrite) NSString *v;
@property (nonatomic, copy, readwrite) NSString *cv;
@property (nonatomic, copy, readwrite) NSString *from;
@property (nonatomic, copy, readwrite) NSString *net;
@property (nonatomic, copy, readwrite) NSString *ip;

@end


@implementation ISNetworkingContext

+ (instancetype)sharedInstance{
    static ISNetworkingContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISNetworkingContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

- (UIDevice *)device{
    if (_device == nil) {
        _device = [UIDevice currentDevice];
    }
    return _device;
}

- (NSString *)m{
    if (_m == nil) {
        _m = [[self.device.model stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]] IS_defaultValue:@""];
    }
    return _m;
}

- (NSString *)o{
    if (_o == nil) {
        _o = [[self.device.systemName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]] IS_defaultValue:@""];
    }
    return _o;
}
- (NSString *)v
{
    if (_v == nil) {
        _v = [self.device systemVersion];
    }
    return _v;
}

- (NSString *)net{
    if (_net == nil) {
        _net = @"";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            _net = @"2G3G4G";
        }
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            _net = @"WiFi";
        }
    }
    return _net;
}

- (NSString *)ip{
    if (_ip == nil) {
        _ip = @"Error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        _ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return _ip;
}

- (BOOL)isReachable{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

@end
