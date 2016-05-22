//
//  ISSettingManager.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSettingManager.h"
#import "SSKeychain.h"


static NSString *SETTING_FIRST_TIME_RUN = @"SETTING_FIRST_TIME_RUN";
static NSString *SETTING_ISLOGINED = @"SETTING_ISLOGINED";
static NSString *SETTING_USER = @"SETTING_USER";
static NSString *SETTING_LASTSYNCDATE = @"SETTING_LASTSYNCDATE";
static NSString *SETTING_DBVERSION = @"SETTING_DBVERSION";
static NSString *SETTING_SERVICE_URL = @"SETTING_SERVICE_URL";
static NSString *SETTING_DEVICE_ID = @"IS_INVENTORY_DEVICE_ID";


@interface ISSettingManager()
@property(nonatomic,strong) NSUserDefaults* userDefaults;
@end

@implementation ISSettingManager

#pragma mark - lifeCycle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISSettingManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISSettingManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        NSObject *setting = [self.userDefaults objectForKey:SETTING_FIRST_TIME_RUN];
        if (!setting) {
            [self.userDefaults setObject:@(1) forKey:SETTING_FIRST_TIME_RUN];
            [self initialSetup];
        }
    }
    return self;
}

/**
 *  copy sqlite file to document path
 */
- (void)initialSetup{
    
    NSString* destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    destPath = [destPath stringByAppendingPathComponent:NSLocalizedString(@"DataBaseName", nil)];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        NSError *error;
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"DataBaseName", nil) ofType:nil];
        if(![[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&error]){
            NSLog(@"%@",[error description]);
        }
    }
    
    NSLog(@"%@",destPath);
}

#pragma mark - getter
- (NSUserDefaults*)userDefaults{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (BOOL)isFirstRun{
    return [self.userDefaults boolForKey:SETTING_FIRST_TIME_RUN];
}

- (BOOL)isLogined{
    return [self.userDefaults boolForKey:SETTING_ISLOGINED];
}

- (NSMutableDictionary*)currentUser{
    return [self.userDefaults valueForKey:SETTING_USER];
}

- (NSDate*)lastSyncDate{
    return [self.userDefaults valueForKey:SETTING_LASTSYNCDATE];
}

- (NSInteger)dBVersion{
    return [self.userDefaults integerForKey:SETTING_DBVERSION];
}

- (NSString*)serviceUrl{
    return [self.userDefaults stringForKey:SETTING_SERVICE_URL];
}

- (NSString*)deviceId{
    NSString * deviceId = [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier]
                                                 account:SETTING_DEVICE_ID];
    if (!deviceId) {
        [SSKeychain setPassword:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                     forService:[[NSBundle mainBundle] bundleIdentifier]
                        account:SETTING_DEVICE_ID];
        deviceId = [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier]
                                          account:SETTING_DEVICE_ID];
    }
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [deviceId substringToIndex:16];
}

#pragma mark - setter
- (void)setLogined:(BOOL)logined{
    [self.userDefaults setBool:logined forKey:SETTING_ISLOGINED];
    [self.userDefaults synchronize];
}

- (void)setCurrentUser:(NSDictionary *)currentUser{
    [self.userDefaults setValue:currentUser forKey:SETTING_USER];
    [self.userDefaults synchronize];
}

- (void)setLastSyncDate:(NSDate *)lastSyncDate{
    [self.userDefaults setValue:lastSyncDate forKey:SETTING_LASTSYNCDATE];
    [self.userDefaults synchronize];
}

- (void)setDBVersion:(NSInteger)dBVersion{
    [self.userDefaults setValue:@(dBVersion) forKey:SETTING_DBVERSION];
    [self.userDefaults synchronize];
}

- (void)setServiceUrl:(NSString *)serviceUrl{
    [self.userDefaults setValue:serviceUrl forKey:SETTING_SERVICE_URL];
    [self.userDefaults synchronize];
}

@end
