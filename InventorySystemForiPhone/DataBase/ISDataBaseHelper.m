//
//  ISDateBaseHelper.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISDataBaseHelper.h"
#import "ISDataBase.h"
#import "ISTypeMapper.h"

#import <objc/message.h>

#import "ISParterDataModel.h"
#import "ISProductDataModel.h"
#import "ISUnitDataModel.h"

static NSString* IS_SQL_checkDataExist = @"select  count(*) from %@ where %@ = '%@'";

@implementation ISDataBaseHelper

+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    static ISDataBaseHelper * sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[ISDataBaseHelper alloc] init];
    });
    return sharedInstance;
}

- (NSArray*)fetchModelListFromSQL:(NSString*)sql withEntity:(NSString*)entity{
    
    NSMutableArray* retList = [NSMutableArray array];
    FMDatabase* db = [[ISDataBase sharedInstance] dataBase];
    FMResultSet* resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        id model = [NSClassFromString(entity) new];
        for(int i = 0; i < [resultSet columnCount]; i++){
            [model setValue:[resultSet stringForColumn:[resultSet columnNameForIndex:i]]
                       forKey:[resultSet columnNameForIndex:i]];
        }
        [retList addObject:model];
    }
    return retList;
}

- (NSArray*)fetchDataFromSQL:(NSString*)sql{
    
    FMDatabase* db = [[ISDataBase sharedInstance] dataBase];
    FMResultSet* resultSet = [db executeQuery:sql];
    NSMutableArray * retList = [NSMutableArray array];
    while ([resultSet next]) {
        [retList addObject:[resultSet stringForColumn:[resultSet columnNameForIndex:0]]];
    }
    return retList;
}





- (void)updateDataBaseByModelList:(NSArray*)modelList block:(ISDataSyncProgressBlock)block{
    if (modelList.count) {
        for(int i = 0; i < modelList.count; i++){
            [self updateDataBaseByModel:modelList[i]];
            if (block) {
                block((i+1)/(float)modelList.count);
            }
        }
    }    
}


- (void)updateDataBaseByModel:(ISBaseModel*)model{
    if (![self checkDataExistsByModel:model]) {
        [self insertDataByModel:model];
    }else{
        [self updateDataByModel:model];
    }
}

/**
 *  检查数据是否已存在
 *
 *  @param model
 *
 *  @return
 */
- (BOOL)checkDataExistsByModel:(ISBaseModel*)model{
    NSArray* retList = [self fetchDataFromSQL:[NSString stringWithFormat:IS_SQL_checkDataExist,
                                               [self getTableFromModel:model],
                                               model.primaryKey,
                                               [model valueForKey:model.primaryKey]]];
    if (retList.count) {
        if (![[retList firstObject] isEqualToString:@"0"]) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  获取Model对应的表名
 *
 *  @param model
 *
 *  @return
 */
- (NSString*)getTableFromModel:(ISBaseModel*)model{
    NSDictionary* mapDic = [ISTypeMapper modelMapDictionary];
    NSString * table = @"";
    for(NSString* v in mapDic.allKeys){
        if ([mapDic[v] isEqualToString:NSStringFromClass([model class])]) {
            table = v;
            break;
        }
    }
    return table;
}

- (void)insertDataByModel:(ISBaseModel*)model{
    
    NSMutableString* strSQL = [NSMutableString string];
    NSArray * properties = [self propertyListFromModel:model];
    NSMutableArray * values = [NSMutableArray array];
    for(int i = 0; i < properties.count; i++){
        [values addObject:[NSString stringWithFormat:@"'%@'",[[ISGDataXMLHelper sharedInstance] safeStringFromData:[model valueForKey:properties[i]]]]];
    }
    
    FMDatabase* db = [[ISDataBase sharedInstance] dataBase];
    [strSQL appendString:[NSString stringWithFormat:@"INSERT INTO %@ (",[self getTableFromModel:model]]];
    [strSQL appendString:[properties componentsJoinedByString:@","]];
    [strSQL appendString:@") VALUES ("];
    [strSQL appendString:[values componentsJoinedByString:@","]];
    [strSQL appendString:@")"];
    [db executeStatements:strSQL];
}

- (void)updateDataByModel:(ISBaseModel*)model{
    
    NSMutableString* strSQL = [NSMutableString string];
    NSArray * properties = [self propertyListFromModel:model];

    FMDatabase* db = [[ISDataBase sharedInstance] dataBase];
    [strSQL appendString:[NSString stringWithFormat:@"UPDATE %@ SET",[self getTableFromModel:model]]];
    
    for (int i = 0; i < properties.count; i++){
        if (![properties[i] isEqualToString:model.primaryKey]) {
            [strSQL appendString:[NSString stringWithFormat:@" %@ = '%@' ",
                                  properties[i],
                                  [[ISGDataXMLHelper sharedInstance] safeStringFromData:[model valueForKey:properties[i]]]]];
            if (i != properties.count - 1) {
                [strSQL appendString:@","];
            }
         }
    }
    
    [strSQL appendString:[NSString stringWithFormat:@" WHERE %@ = '%@'",
                          model.primaryKey,
                          [model valueForKey:model.primaryKey]]];
    [db executeStatements:strSQL];
}

- (NSArray*)propertyListFromModel:(ISBaseModel*)model{
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

@end
