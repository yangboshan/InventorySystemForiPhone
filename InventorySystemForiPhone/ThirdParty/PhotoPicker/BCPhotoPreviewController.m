//
//  BCPhotoPreviewController.m
//  TripAway
//
//  Created by yangboshan on 16/3/10.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import "BCPhotoPreviewController.h"
#import "BCPhotoAssetBottomBar.h"

@interface BCPhotoPreviewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) NSMutableArray* dataList;
@property (nonatomic,copy)   BCPhotoPreviewBlock block;
@property (nonatomic,strong) BCPhotoAssetBottomBar* bottomBar;
@property (nonatomic,strong) UILabel* titleView;
@property (nonatomic,strong) UIButton* rightBtn;
@property (nonatomic,assign) int currentPage;


@end

@implementation BCPhotoPreviewController

static float const bottomHeight = 45;


- (instancetype)initWithData:(NSArray *)data block:(BCPhotoPreviewBlock)block{
    if (self = [super init]) {
        _block = [block copy];
        _dataList = [data copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = self.titleView;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.bottomBar];
    [self.view addSubview:self.rightBtn];
    
    [self.bottomBar updateStatus:self.dataList];
    
    for(int i = 0; i < self.dataList.count; i++){
        NSDictionary* d = self.dataList[i];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, CGRectGetHeight(self.scrollView.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = d[@"image"];
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark - event

- (void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishAction:(UIButton*)sender{
    if (self.block) {
        self.block([@(NO) boolValue],nil,[@(YES) boolValue]);
    }
}

- (void)changeStatus:(UIButton*)sender{
    NSMutableDictionary* d = self.dataList[self.currentPage];
    if ([[d valueForKey:@"status"] boolValue]) {
        [d setValue:@(NO) forKey:@"status"];
        sender.selected = NO;
    }else{
        [d setValue:@(YES) forKey:@"status"];
        sender.selected = YES;
        
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.05),@(1.1),@(1.05),@(0.9),@(1.0)];
        k.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        k.duration = 0.5f;
        [sender.layer addAnimation:k forKey:@"SHOW"];
    }
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"status == 1"];
    [self.bottomBar updateStatus:[self.dataList filteredArrayUsingPredicate:predicate]];
    if (self.block) {
        self.block([d[@"status"] boolValue],d[@"indexPath"],[@(NO) boolValue]);
    }
}

- (void)updateStatus{
    NSMutableDictionary* d = self.dataList[self.currentPage];
    if ([[d valueForKey:@"status"] boolValue]) {
        self.rightBtn.selected = YES;
    }else{
        self.rightBtn.selected = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / ScreenWidth;
    self.currentPage = page;
    self.titleView.text = [NSString stringWithFormat:@"%d/%d",(int)++page,(int)self.dataList.count];
    [self updateStatus];
}

#pragma mark - property

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(ScreenWidth * self.dataList.count, ScreenHeight - NavBarHeight);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (BCPhotoAssetBottomBar*)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [[[NSBundle mainBundle] loadNibNamed:@"BCPhotoAssetBottomBar" owner:nil options:nil] lastObject];
        _bottomBar.previewBtn.hidden = YES;
        _bottomBar.frame = CGRectMake(0, ScreenHeight - bottomHeight, ScreenWidth, bottomHeight);
        [_bottomBar.finishBtn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBar;
}

- (UILabel*)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _titleView.font = LantingheiBold(18);
        _titleView.textColor = [UIColor whiteColor];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.text = [NSString stringWithFormat:@"1/%d",(int)self.dataList.count];
    }
    return _titleView;
}

- (UIButton*)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 80, NavBarHeight + 20, 80, 40)];
        [_rightBtn setImage:[UIImage imageNamed:@"photopicker_unchecked"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"photopicker_checked"] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.selected = YES;
    }
    return _rightBtn;
}

@end
