//
//  ISLocationManager.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/20.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISLocationManager : NSObject

@property (nonatomic, strong) NSString * fetchedLocation;

+ (instancetype)sharedInstance;

- (void)startUpdatingLocation;

@end
