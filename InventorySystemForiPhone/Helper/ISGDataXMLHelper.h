//
//  ISGDataXMLHelper.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GDataXML-HTML/GDataXMLNode.h>

@interface ISGDataXMLHelper : NSObject

+ (instancetype)sharedInstance;

/**
 *  non nil
 *
 *  @param data
 *
 *  @return
 */
- (NSString*)safeStringFromData:(id)data;

/**
 *  从XML获取Model
 *
 *  @param element
 */
- (id)fetchModelFromXMLElement:(GDataXMLElement*)element withEntity:(NSString*)entity;
@end
