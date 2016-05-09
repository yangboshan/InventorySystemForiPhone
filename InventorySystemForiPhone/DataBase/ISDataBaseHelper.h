//
//  ISDateBaseHelper.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@class GDataXMLElement;


typedef void(^ISDataSyncProgressBlock)(float progress);

@interface ISDataBaseHelper : NSObject


+ (instancetype)sharedInstance;

/**
 *  从数据库获取Model 列表
 *
 *  @param sql
 *  @param entity
 *
 *  @return model list
 */
- (NSArray*)fetchModelListFromSQL:(NSString*)sql withEntity:(NSString*)entity;

/**
 *  从数据库获取列表
 *
 *  @param sql
 *
 *  @return list
 */
- (NSArray*)fetchDataFromSQL:(NSString*)sql;

/**
 *  更新Model到数据库
 *
 *  @param entity
 */
- (void)updateDataBaseByModelList:(NSArray*)modelList block:(ISDataSyncProgressBlock)block;

/**
 *  从XML获取Model
 *
 *  @param element
 */
- (id)fetchModelFromXMLElement:(GDataXMLElement*)element withEntity:(NSString*)entity;

@end
