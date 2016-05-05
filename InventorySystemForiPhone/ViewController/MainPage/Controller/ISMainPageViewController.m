//
//  ISMainPageViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISMainPageViewController.h"
#import "ISLoginViewController.h"
#import "ISMainPageViewModel.h"
#import "ISMainPageCollectionViewCell.h"

@interface ISMainPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic,strong) NSArray* dataList;
@property (nonatomic,strong) ISMainPageViewModel* mainPageViewModel;
@end

@implementation ISMainPageViewController

static NSString* mainPageCell = @"ISMainPageCollectionViewCell";
static float cellMargin = 10;
static int   cellPerRow = 4;

#pragma mark - life Cycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kISLoginDidSuccessNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    self.dataList = [self.mainPageViewModel fetchFormatDataSource];
    
    [self.view setBackgroundColor:RGB(243, 244, 245)];
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidSuccess:) name:kISLoginDidSuccessNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![ISSettingManager sharedInstance].isLogined) {
        ISLoginViewController* loginController = [ISLoginViewController new];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - methods

- (void)loginDidSuccess:(NSNotification*)notification{
    self.dataList = [self.mainPageViewModel fetchFormatDataSource];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ISMainPageCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:mainPageCell forIndexPath:indexPath];
    cell.data = self.dataList[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth - cellMargin * (cellPerRow + 1))/cellPerRow, (ScreenWidth - cellMargin * (cellPerRow + 1))/cellPerRow);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return cellMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return cellMargin;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* d = self.dataList[indexPath.row];
    if (![NSString stringIsNilOrEmpty:d[@"vc"]]) {
        id controller = [NSClassFromString(d[@"vc"]) new];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"敬请期待" InView:self.view];
    }
}


#pragma mark - property

- (UICollectionView*)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_collectionView registerNib:[UINib nibWithNibName:mainPageCell bundle:nil] forCellWithReuseIdentifier:mainPageCell];
        _collectionView.backgroundColor = RGB(243, 244, 245);
    }
    return _collectionView;
}

- (ISMainPageViewModel*)mainPageViewModel{
    if (_mainPageViewModel == nil) {
        _mainPageViewModel = [ISMainPageViewModel new];
    }
    return _mainPageViewModel;
}

@end
