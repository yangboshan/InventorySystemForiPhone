//
//  BCScanViewController.m
//  TripAway4Server
//
//  Created by yangboshan on 15/12/22.
//  Copyright (c) 2015年 yangbs. All rights reserved.
//

#import "ISScanViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "ZBarSDK.h"
#import "ISScanView.h"

@interface ISScanViewController ()<ZBarReaderViewDelegate>
@property (nonatomic,strong) ZBarReaderView *readerView;
@property (nonatomic,strong) ZBarCameraSimulator *cameraSimulator;
@property (nonatomic,strong) ISScanView *scanView;
@end

@implementation ISScanViewController

#pragma mark - lifeCycle

- (void)dealloc {
    _readerView.readerDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (TARGET_IPHONE_SIMULATOR) {
        self.cameraSimulator = [[ZBarCameraSimulator alloc] initWithViewController:self];
        self.cameraSimulator.readerView = self.readerView;
    }
    [self.view addSubview:self.readerView];
    
    CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(self.readerView.frame) - 126, 200, 200);
    self.readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:self.readerView.bounds];
    
    [self.view addSubview:self.scanView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.readerView start];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.readerView stop];
}

#pragma mark - 

- (void)playSoundWithName:(NSString *)name type:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else {
        NSLog(@"Error: audio file not found at path: %@", path);
    }
}

- (void)playSound{
    [self playSoundWithName:@"qrcode_found" type:@"wav"];
}

- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds{
    CGFloat x,y,width,height;
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    height = 1 - rect.origin.x / rvBounds.size.width;
    return CGRectMake(x, y, width, height);
}

#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    
    [self playSound];
    
    for (ZBarSymbol *sym in symbols) {
        if (self.block) {
            self.block(sym.data);
        }
        break;
    }
}

#pragma mark - property

- (ISScanView*)scanView{
    if (!_scanView) {
        _scanView = [[ISScanView alloc] initWithFrame:CGRectMake(0, NavBarHeightAlone,ScreenWidth, ScreenHeight - NavBarHeightAlone)];
        [_scanView setBackgroundColor:[UIColor clearColor]];
    }
    return _scanView;
}

- (ZBarReaderView*)readerView{
    if (!_readerView) {
        _readerView = [[ZBarReaderView alloc] init];
        _readerView.frame = self.view.bounds;
        _readerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _readerView.readerDelegate = self;
        _readerView.torchMode = 0;
        
        if (TARGET_IPHONE_SIMULATOR) {
            self.cameraSimulator = [[ZBarCameraSimulator alloc] initWithViewController:self];
            self.cameraSimulator.readerView = _readerView;
        }
    }
    return _readerView;
}


@end
