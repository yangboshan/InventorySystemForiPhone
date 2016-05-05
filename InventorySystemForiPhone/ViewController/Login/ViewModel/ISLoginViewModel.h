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

- (BOOL)checkLoginInfoByUserName:(NSString*)userName userPsw:(NSString*)userPsw;

@end
