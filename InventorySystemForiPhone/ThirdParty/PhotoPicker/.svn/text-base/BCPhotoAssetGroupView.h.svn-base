//
//  BCPhotoAssetGroupView.h
//  TripAway
//
//  Created by yangboshan on 16/3/9.
//  Copyright (c) 2016年 yangbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^GroupSelectBlock)(ALAssetsGroup* group);

@interface BCPhotoAssetGroupView : UIView

@property (nonatomic,assign) BOOL isActive;


- (instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data titleView:(UIButton*)titleView block:(GroupSelectBlock)block;

- (void)toggleBoard;

@end
