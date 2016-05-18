//
//  ISMainPageViewModel.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISMainPageViewModel : NSObject

/**
 *  是否有同步数据的权限
 */
@property (nonatomic,assign) BOOL hasPrivilegeForSyncData;

/**
 *  是否有报表权限
 */
@property (nonatomic,assign) BOOL hasPrivilegeForReport;

/**
 *  是否必须拍照片
 */
@property (nonatomic,assign) BOOL shouldShootPhoto;

/**
 *  是否必须定位
 */
@property (nonatomic,assign) BOOL shouldLocation;


/**
 *  主页数据源
 *
 *  @return datasource
 */
- (NSArray*)fetchFormatDataSource;



@end
