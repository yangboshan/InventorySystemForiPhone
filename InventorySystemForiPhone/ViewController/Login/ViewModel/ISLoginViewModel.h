//
//  ISLoginViewModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISLoginViewModel : NSObject

+ (instancetype)sharedInstance;

/**
 *  验证用户名密码
 *
 *  @param userName 用户名
 *  @param userPsw  密码
 *
 *  @return 布尔值
 */
- (BOOL)checkLoginInfoByUserName:(NSString*)userName userPsw:(NSString*)userPsw;

@end
