//
//  ISNetworkingServiceProviderFactory.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/28.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingServiceProviderFactory.h"
#import "ISNetworkingSOAPServiceProvider.h"
#import "ISNetworkingHostServiceProvider.h"

@interface ISNetworkingServiceProviderFactory()

@property (nonatomic, strong) NSCache *serviceStorage;


@end

@implementation ISNetworkingServiceProviderFactory

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISNetworkingServiceProviderFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISNetworkingServiceProviderFactory alloc] init];
    });
    return sharedInstance;
}


- (ISNetworkingBaseServiceProvider<ISNetworkingBaseServiceProviderProtocol>*)serviceProviderByIdentifier:(NSString *)identifier{
    if ([self.serviceStorage objectForKey:identifier] == nil) {
        [self.serviceStorage setObject:[self newServiceProviderByIdentifier:identifier] forKey:identifier];
    }
    return [self.serviceStorage objectForKey:identifier];
}

- (ISNetworkingBaseServiceProvider<ISNetworkingBaseServiceProviderProtocol>*)newServiceProviderByIdentifier:(NSString *)identifier{
    
    if ([identifier isEqualToString:NSStringFromClass([ISNetworkingSOAPServiceProvider class])]) {
        return [ISNetworkingSOAPServiceProvider new];
    }
    if ([identifier isEqualToString:NSStringFromClass([ISNetworkingHostServiceProvider class])]) {
        return [ISNetworkingHostServiceProvider new];
    }
    return nil;
}

#pragma mark - getters and setters

- (NSCache *)serviceStorage{
    
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSCache alloc] init];
        _serviceStorage.countLimit = 5;
    }
    return _serviceStorage;
}

@end
