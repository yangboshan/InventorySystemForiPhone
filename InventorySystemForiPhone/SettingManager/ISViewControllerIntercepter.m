//
//  ISViewControllerIntercepter.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISViewControllerIntercepter.h"
#import <Aspects/Aspects.h>
#import <UIKit/UIKit.h>
#import "NSObject+ISNetworking.h"

@implementation ISViewControllerIntercepter

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISViewControllerIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISViewControllerIntercepter alloc] init];
    });
    return sharedInstance;
}

+ (void)load{
    [super load];
    [ISViewControllerIntercepter sharedInstance];
}

- (instancetype)init{
    if (self = [super init]) {
        
        [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self viewDidLoad:[aspectInfo instance]];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewWillAppear:animated viewController:[aspectInfo instance]];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewWillAppear:animated viewController:[aspectInfo instance]];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewWillDisappear:animated viewController:[aspectInfo instance]];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewDidDisappear:animated viewController:[aspectInfo instance]];
        } error:NULL];
        
    }
    return self;
}

/**
 *  hook viewDidLoad
 *
 *  @param viewController
 */
- (void)viewDidLoad:(UIViewController *)viewController{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString* selfClass = [NSString stringWithFormat:@"%@",[viewController class]];
    viewController.title = NSLocalizedString(selfClass, nil);
#ifdef DEBUG    
//    NSLog(@"[%@ viewDidLoad]", [[viewController title] IS_isEmptyObject] ? [viewController class] : [viewController title]);
#endif

}

/**
 *  hook viewWillAppear
 *
 *  @param animated
 *  @param viewController
 */
- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController{
#ifdef DEBUG
//    NSLog(@"[%@ viewWillAppear:%@]", [[viewController title] IS_isEmptyObject] ? [viewController class] : [viewController title], animated ? @"YES" : @"NO");
#endif

}


/**
 *  hook viewDidAppear
 *
 *  @param animated
 *  @param viewController
 */
- (void)viewDidAppear:(BOOL)animated viewController:(UIViewController *)viewController{
#ifdef DEBUG
//    NSLog(@"[%@ viewDidAppear:%@]", [[viewController title] IS_isEmptyObject] ? [viewController class] : [viewController title], animated ? @"YES" : @"NO");
#endif
}


/**
 *  hook viewWillDisappear
 *
 *  @param animated
 *  @param viewController
 */
- (void)viewWillDisappear:(BOOL)animated viewController:(UIViewController *)viewController{
#ifdef DEBUG
//    NSLog(@"[%@ viewWillDisappear:%@]", [[viewController title] IS_isEmptyObject] ? [viewController class] : [viewController title], animated ? @"YES" : @"NO");
#endif
}


/**
 *  hook viewDidDisappear
 *
 *  @param animated
 *  @param viewController
 */
- (void)viewDidDisappear:(BOOL)animated viewController:(UIViewController *)viewController{
#ifdef DEBUG
//    NSLog(@"[%@ viewDidDisappear:%@]", [[viewController title] IS_isEmptyObject] ? [viewController class] : [viewController title], animated ? @"YES" : @"NO");
#endif
}

@end
