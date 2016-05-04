//
//  ISNetworkingCache.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/29.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingCache.h"
#import "ISNetworkingConfiguration.h"
#import "ISNetworkingCacheObject.h"

@interface ISNetworkingCache ()
@property (nonatomic, strong) NSCache *cache;

@end

@implementation ISNetworkingCache

#pragma mark - getters and setters
- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kISCacheCountLimit;
    }
    return _cache;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISNetworkingCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISNetworkingCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key{
    ISNetworkingCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}


- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key{
    ISNetworkingCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[ISNetworkingCacheObject alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    return [NSString stringWithFormat:@"%@%@", serviceIdentifier, methodName];
}


- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)clean{
    [self.cache removeAllObjects];
}

@end
