//
//  AppDelegate.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/4/26.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "AppDelegate.h"
#import "ISMainPageViewController.h"
#import "ISDataSyncModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initialSetup];
    
    ISMainPageViewController* mainPageController = [ISMainPageViewController new];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:mainPageController];
    self.window.rootViewController = navController;
    
    if ([ISSettingManager sharedInstance].isLogined) {
//        [[ISDataSyncModel sharedInstance] startSync];
    }
    
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - config

- (void)initialSetup{
    [ISSettingManager sharedInstance];
    [self customizeAppearance];
}

- (void)customizeAppearance{
    
    [[UINavigationBar appearance] setBarTintColor:TheameColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:1.0],NSFontAttributeName:Lantinghei(20.0)}];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UIBarButtonItem appearance].tintColor = [UIColor whiteColor];
}

@end
