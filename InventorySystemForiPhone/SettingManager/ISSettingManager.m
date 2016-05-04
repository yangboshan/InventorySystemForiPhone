//
//  ISSettingManager.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSettingManager.h"

static NSString *SETTING_FIRST_TIME_RUN = @"SETTING_FIRST_TIME_RUN";
static NSString *SETTING_ISLOGINED = @"SETTING_ISLOGINED";
static NSString *SETTING_USER = @"SETTING_USER";


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
    destPath = [destPath stringByAppendingPathComponent:@"LinoonInv.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        NSError *error;
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"LinoonInv.sqlite" ofType:nil];
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

- (NSDictionary*)currentUser{
    return [self.userDefaults valueForKey:SETTING_USER];
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

@end
