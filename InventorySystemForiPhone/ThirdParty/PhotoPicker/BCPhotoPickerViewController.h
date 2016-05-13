//
//  BCPhotoPickerViewController.h
//  TripAway
//
//  Created by yangboshan on 16/3/8.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^BCPhotoPickerFinishBlock)(NSArray* data);

@interface BCPhotoPickerViewController : UINavigationController

@property (nonatomic,assign) NSInteger maxOfSelection;
@property (nonatomic,assign) NSInteger minOfSelection;
@property (nonatomic,strong) ALAssetsFilter *assetsFilter;
@property (nonatomic,assign) BOOL scrollToBottom;
@property (nonatomic,assign) BOOL enableCamara;

@property (nonatomic,copy) BCPhotoPickerFinishBlock block;


@end
