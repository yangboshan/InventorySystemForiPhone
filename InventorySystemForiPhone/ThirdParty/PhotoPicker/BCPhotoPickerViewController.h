//
//  BCPhotoPickerViewController.h
//  TripAway
//
//  Created by yangboshan on 16/3/8.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger,BCPhotoPickerType){
    BCPhotoPickerTypeCamare = 0,
    BCPhotoPickerTypeAlbum = 1
};

typedef void(^BCPhotoPickerFinishBlock)(NSArray* data,BCPhotoPickerType type);

@interface BCPhotoPickerViewController : UINavigationController

@property (nonatomic,assign) NSInteger maxOfSelection;
@property (nonatomic,assign) NSInteger minOfSelection;
@property (nonatomic,strong) ALAssetsFilter *assetsFilter;
@property (nonatomic,assign) BOOL scrollToBottom;
@property (nonatomic,assign) BOOL enableCamara;

@property (nonatomic,copy) BCPhotoPickerFinishBlock block;


@end
