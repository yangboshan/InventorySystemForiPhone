//
//  ISDataSyncModel.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/6.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISDataSyncModel.h"
#import "ISDataBase.h"
#import "ISTypeMapper.h"
#import "ISNetworkingSyncAPIHandler.h"
#import "ISDataSyncFormatterKeys.h"

static NSString* IS_SQL_GetUpdateTable = @"select tableName from t_TableUpdateList";
static NSString* IS_SQL_GetLastUpdate = @"select ifnull(max(ifnull(UPD_DATE,CRE_DATE)),'2000-01-01T13:39:00+08:00') from ";

@interface ISDataSyncModel()<ISNetworkingAPIHandlerCallBackDelegate,ISNetworkingAPIHandlerParamSourceDelegate>
@property (nonatomic,assign,readwrite) ISDataSyncStatus status;
@property (nonatomic,assign,readwrite) float progress;
@property (nonatomic,strong) NSMutableArray* updateList;
@property (nonatomic,strong) NSMutableArray * dataSyncQueue;
@property (nonatomic,strong) ISNetworkingSyncAPIHandler * syncAPIHander;
- (void)prepareSyscParams;
@end

@implementation ISDataSyncModel

#pragma mark - 

- (instancetype)init{
    if (self = [super init]) {
        _status = ISDataSyncStatusDefault;
    }
    return self;
}

+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    static ISDataSyncModel * sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[ISDataSyncModel alloc] init];
    });
    return sharedInstance;
}

#pragma mark -

- (void)startSync{
    
    self.status = ISDataSyncStatusSyncing;
    self.progress = 0.0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self prepareSyscParams];
        [self.syncAPIHander loadData];
    });
}

- (void)prepareSyscParams{
    
    self.updateList = [NSMutableArray array];
    NSArray * needUpdateTableList = [[ISDataBaseHelper sharedInstance] fetchDataFromSQL:IS_SQL_GetUpdateTable];
    for(NSString* table in needUpdateTableList){
        NSString* lastUpdate = [[[ISDataBaseHelper sharedInstance] fetchDataFromSQL:[NSString stringWithFormat:@"%@ %@",IS_SQL_GetLastUpdate,table]] firstObject];
        
        [self.updateList addObject:@{@"sTableName":table,@"sFromDateTime":[[NSDate dateFromString:lastUpdate withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"] dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"]}];
    }
    self.dataSyncQueue = [self.updateList mutableCopy];
}

#pragma mark - ISNetworkingAPIHandlerCallBackDelegate

- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([manager isKindOfClass:[ISNetworkingSyncAPIHandler class]]) {
            NSString * tableName =  [[self.dataSyncQueue firstObject] valueForKey:@"sTableName"];
            NSString * formatterId =  [[ISTypeMapper formatterMapDictionary] valueForKey:tableName];
            id<ISNetworkingAPIHandlerCallBackReformer> formatter = [NSClassFromString(formatterId) new];
            NSDictionary* data = [formatter manager:manager reformData:manager.fetchedRawData];
            NSArray* modelList = data[kISDataSyncResut];
            if (modelList.count) {
                float completeProgress = (1.0/self.updateList.count) * (self.updateList.count -  self.dataSyncQueue.count);
                __weak typeof(self) weakSelf = self;
                [[ISDataBaseHelper sharedInstance] updateDataBaseByModelList:modelList block:^(float progress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.progress = completeProgress + (1.0/weakSelf.updateList.count) * progress;
                    });
                }];
            }
            if (self.dataSyncQueue.count) {
                [self.dataSyncQueue removeObjectAtIndex:0];
            }
            
            if (self.dataSyncQueue.count) {
                sleep(1.0);
                [self.syncAPIHander loadData];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.status = ISDataSyncStatusFinished;
                    [ISSettingManager sharedInstance].lastSyncDate = [NSDate currentDate];
                });
            }
        }
    });
}

- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.status = ISDataSyncStatusError;
        self.progress = .0;
    });
}

#pragma mark - ISNetworkingAPIHandlerParamSourceDelegate

- (NSDictionary*)paramsForApi:(ISNetworkingBaseAPIHandler *)manager{
    return [self.dataSyncQueue firstObject];
}


#pragma mark -  property

- (ISNetworkingSyncAPIHandler*)syncAPIHander{
    if (_syncAPIHander == nil) {
        _syncAPIHander = [[ISNetworkingSyncAPIHandler alloc] init];
        _syncAPIHander.delegate = self;
        _syncAPIHander.paramSource = self;
    }
    return _syncAPIHander;
}
@end
