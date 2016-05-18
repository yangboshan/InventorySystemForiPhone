//
//  BCSquareImageEditorController.m
//  TripAway
//
//  Created by yangboshan on 16/3/15.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import "ISImageEditorController.h"

@interface ISImageEditorController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSMutableArray* dataList;
@property (nonatomic, copy)   ISImageEditorBlock block;
@property (nonatomic, strong) UILabel* titleView;
@property (nonatomic, assign) int currentPage;

@end

@implementation ISImageEditorController

- (instancetype)initWithData:(NSMutableArray*)data block:(ISImageEditorBlock)block{
    if (self = [super init]) {
        _block = [block copy];
        _dataList = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"order_list_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteItem:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [self setupScrollView];
}

- (void)setupScrollView{
    
    for(int i = 0; i < self.dataList.count; i++){
        NSDictionary* d = self.dataList[i];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, CGRectGetHeight(self.scrollView.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = d[@"image"];
        [self.scrollView addSubview:imageView];
    }
    [self.view addSubview:self.scrollView];
    self.title = [NSString stringWithFormat:@"1/%d (%@)",(int)self.dataList.count,[self.dataList firstObject][@"remark"]];
}

- (void)deleteItem:(UIButton*)sender{
    [self.dataList removeObjectAtIndex:self.currentPage];
    if (self.block) {
        self.block(nil);
    }
    if (self.dataList.count) {
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
        [self setupScrollView];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.currentPage = 0;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / ScreenWidth;
    self.currentPage = page;
    self.title = [NSString stringWithFormat:@"%d/%d (%@)",(int)++page,(int)self.dataList.count,self.dataList[self.currentPage][@"remark"]];
}

#pragma mark - property

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight)];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.contentSize = CGSizeMake(ScreenWidth * self.dataList.count, ScreenHeight - NavBarHeight);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
@end
