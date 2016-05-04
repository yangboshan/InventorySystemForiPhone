//
//  ISNetworkingCacheObject.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/29.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISNetworkingCacheObject.h"
#import "ISNetworkingConfiguration.h"

@interface ISNetworkingCacheObject ()
@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;
@end

@implementation ISNetworkingCacheObject

#pragma mark - getters and setters
- (BOOL)isEmpty{
    return self.content == nil;
}

- (BOOL)isOutdated{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > kISCacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}


#pragma mark - life cycle
- (instancetype)initWithContent:(NSData *)content{
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}

#pragma mark - public method
- (void)updateContent:(NSData *)content{
    self.content = content;
}

@end
