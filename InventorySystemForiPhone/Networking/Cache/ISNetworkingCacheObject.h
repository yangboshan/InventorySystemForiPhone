//
//  ISNetworkingCacheObject.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/29.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISNetworkingCacheObject : NSObject

@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (void)updateContent:(NSData *)content;

@end
