//
//  ISMainPageViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISMainPageViewController.h"
#import "ISLoginViewController.h"
#import "ISRemainTimeViewController.h"

#import "ISMainPageViewModel.h"
#import "ISNetworkingRemainTimeAPIHandler.h"
#import "ISRemainTimeFormatter.h"

#import "ISMainPageCollectionViewCell.h"
#import "ISMainPageHeaderView.h"

#import "ISDataSyncModel.h"


@interface ISMainPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ISNetworkingAPIHandlerCallBackDelegate,ISNetworkingAPIHandlerParamSourceDelegate>

@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic,strong) NSArray* dataList;
@property (nonatomic,strong) ISMainPageViewModel * mainPageViewModel;
@property (nonatomic,strong) ISMainPageHeaderView * headerView;
@property (nonatomic,strong) ISNetworkingRemainTimeAPIHandler * remainTimeAPIHandler;
@property (nonatomic,strong) ISRemainTimeFormatter * remainTimeFormatter;
@end

@implementation ISMainPageViewController

static NSString* mainPageCell = @"ISMainPageCollectionViewCell";
static float cellMargin = 10;
static int   cellPerRow = 4;
static float timeViewHeight = 50;

#pragma mark - life Cycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kISLoginDidSuccessNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    
    if ([ISSettingManager sharedInstance].isLogined) {
        [self.remainTimeAPIHandler loadData];
    }
    
    self.dataList = [self.mainPageViewModel fetchFormatDataSource];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headerView];
    self.headerView.deviceIdLabel.text = [[UIDevice currentDevice].IS_macaddressMD5 uppercaseString];
    [self autolayoutSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidSuccess:) name:kISLoginDidSuccessNotification object:nil];
}

- (void)autolayoutSubView{
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, timeViewHeight, 0)];
    [self.headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(ScreenHeight - timeViewHeight, 0, 0, 0)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![ISSettingManager sharedInstance].isLogined) {
        [self showLoginController];
    }
}

#pragma mark - ISNetworkingAPIHandlerCallBackDelegate

- (void)managerCallAPIDidSuccess:(ISNetworkingBaseAPIHandler *)manager{
    
    if ([manager isKindOfClass:[ISNetworkingRemainTimeAPIHandler class]]) {
        NSDictionary* data = [self.remainTimeFormatter manager:manager reformData:manager.fetchedRawData];
        self.headerView.remainTimeLabel.text = [NSString stringWithFormat:@"%@天",[data[kISRemainTimeResut] IS_defaultValue:@"0"]];
        if ([data[kISRemainTimeResut] IS_isEmptyObject]) {
            UINavigationController* nav = [self showChargeControllerByFlag:YES];
            [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"没有使用时间啦，去充值吧" InView:nav.view];
        }
    }
}

- (void)managerCallAPIDidFailed:(ISNetworkingBaseAPIHandler *)manager{
    [[ISProcessViewHelper sharedInstance] showProcessViewWithText:@"ERROR" InView:self.view];
}

#pragma mark - ISNetworkingAPIHandlerParamSourceDelegate

- (NSDictionary*)paramsForApi:(ISNetworkingBaseAPIHandler *)manager{
    if ([manager isKindOfClass:[ISNetworkingRemainTimeAPIHandler class]]) {
        NSLog(@"%@",[[UIDevice currentDevice] IS_macaddressMD5]);
        return @{@"HashID":[[UIDevice currentDevice] IS_macaddressMD5]};
    }
    return nil;
}

#pragma mark - methods

- (void)loginDidSuccess:(NSNotification*)notification{
    self.dataList = [self.mainPageViewModel fetchFormatDataSource];
    [self.collectionView reloadData];
    [self.remainTimeAPIHandler loadData];
    [[ISDataSyncModel sharedInstance] startSync];
}

- (void)showLoginController{
    ISLoginViewController* loginController = [ISLoginViewController new];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)goCharge:(UIButton*)sender{
    [self showChargeControllerByFlag:NO];
}

- (UINavigationController*)showChargeControllerByFlag:(BOOL)flag{
    ISRemainTimeViewController* controller = [ISRemainTimeViewController new];
    controller.noTimeLeft = flag;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    return nav;
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGB(239, 244, 244);
        [_collectionView registerNib:[UINib nibWithNibName:mainPageCell bundle:nil] forCellWithReuseIdentifier:mainPageCell];
    }
    return _collectionView;
}

- (ISMainPageHeaderView*)headerView{
    if (_headerView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ISMainPageHeaderView" owner:nil options:nil] firstObject];
        [_headerView.remainTimeBtn addTarget:self action:@selector(goCharge:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (ISMainPageViewModel*)mainPageViewModel{
    if (_mainPageViewModel == nil) {
        _mainPageViewModel = [ISMainPageViewModel new];
    }
    return _mainPageViewModel;
}

- (ISNetworkingRemainTimeAPIHandler*)remainTimeAPIHandler{
    if (_remainTimeAPIHandler == nil) {
        _remainTimeAPIHandler = [ISNetworkingRemainTimeAPIHandler new];
        _remainTimeAPIHandler.delegate = self;
        _remainTimeAPIHandler.paramSource = self;
    }
    return _remainTimeAPIHandler;
}

- (ISRemainTimeFormatter*)remainTimeFormatter{
    if (!_remainTimeFormatter) {
        _remainTimeFormatter = [ISRemainTimeFormatter new];
    }
    return _remainTimeFormatter;
}

@end
