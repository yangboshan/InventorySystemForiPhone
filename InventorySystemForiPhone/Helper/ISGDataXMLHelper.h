//
//  ISGDataXMLHelper.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISGDataXMLHelper : NSObject

+ (instancetype)sharedInstance;

- (NSString*)safeStringFromData:(id)data;

@end
