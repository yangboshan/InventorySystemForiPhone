//
//  BCPhotoPickerViewController.m
//  TripAway
//
//  Created by yangboshan on 16/3/8.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import "BCPhotoPickerViewController.h"
#import "BCPhotoAssetViewController.h"

@interface BCPhotoPickerViewController ()

@end

@implementation BCPhotoPickerViewController

- (instancetype)init{
    
    BCPhotoAssetViewController* assetViewController = [BCPhotoAssetViewController new];
    if (self = [super initWithRootViewController:assetViewController]) {
        _maxOfSelection = 9;
        _minOfSelection = 0;
        _scrollToBottom = NO;
        _enableCamara = YES;
        _assetsFilter = [ALAssetsFilter allPhotos];
        self.preferredContentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
