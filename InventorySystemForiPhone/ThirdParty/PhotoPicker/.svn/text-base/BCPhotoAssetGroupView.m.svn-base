//
//  BCPhotoAssetGroupView.m
//  TripAway
//
//  Created by yangboshan on 16/3/9.
//  Copyright (c) 2016年 yangbs. All rights reserved.
//

#import "BCPhotoAssetGroupView.h"
#import "BCPhotoAssetGroupCell.h"

@interface BCPhotoAssetGroupView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UIView* bgView;
@property (nonatomic,strong) UIButton* titleView;


@property (nonatomic,copy) GroupSelectBlock block;
@property (nonatomic,copy) NSArray* dataList;

@end

@implementation BCPhotoAssetGroupView

static NSString* const groupCell = @"BCPhotoAssetGroupCell";
static float const cellHeight = 60;
static float const topOffset = 7;
static NSTimeInterval const bounceInterval = 0.15;
static NSTimeInterval const mainInterval = 0.35;

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data titleView:(UIButton*)titleView block:(GroupSelectBlock)block{
    if (self = [super initWithFrame:frame]) {
        _block = [block copy];
        _dataList = [data copy];
        _isActive = NO;
        _titleView = titleView;
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* d = self.dataList[indexPath.row];
    ALAssetsGroup* group = [d valueForKey:@"type"];
    
    BCPhotoAssetGroupCell* cell = [tableView dequeueReusableCellWithIdentifier:groupCell];
    cell.groupImageView.image  = [UIImage imageWithCGImage:group.posterImage];
    cell.groupLabel.text = [NSString stringWithFormat:@"%@ %ld",[group valueForProperty:ALAssetsGroupPropertyName],(long)[group numberOfAssets]];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ALAssetsGroup* group = [self.dataList[indexPath.row] valueForKey:@"type"];
    if (self.block) {
        self.block(group);
    }
    [self toggleBoard];
}

#pragma mark - event

- (void)dismiss:(UIGestureRecognizer*)gesture{
    self.titleView.selected = NO;
    [self toggleBoard];
}

- (void)toggleBoard{
    if (!self.isActive) {
        [UIView transitionWithView:self.tableView duration:mainInterval options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tableView.frame = CGRectMake(0,
                                              0,
                                              CGRectGetWidth(self.frame),
                                              cellHeight * self.dataList.count + topOffset);
            self.bgView.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView transitionWithView:self.tableView duration:bounceInterval options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.tableView.frame = CGRectMake(0,
                                                  - topOffset,
                                                  CGRectGetWidth(self.frame),
                                                  cellHeight * self.dataList.count + topOffset);
            } completion:^(BOOL finished) {
                self.isActive = YES;
            }];
        }];
    }else{
        [UIView transitionWithView:self.tableView duration:bounceInterval options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tableView.frame = CGRectMake(0,
                                              0,
                                              CGRectGetWidth(self.frame),
                                              cellHeight * self.dataList.count + topOffset);
        } completion:^(BOOL finished) {
            [UIView transitionWithView:self.tableView duration:mainInterval options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.tableView.frame = CGRectMake(0,
                                                  - cellHeight * self.dataList.count - topOffset,
                                                  CGRectGetWidth(self.frame),
                                                  cellHeight * self.dataList.count + topOffset);
                self.bgView.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                self.isActive = NO;
            }];
        }];
    }
}

#pragma mark - property

- (UIView*)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [_bgView addGestureRecognizer:tap];
        _bgView.backgroundColor = MaskColor;
        _bgView.alpha = .0;
    }
    return _bgView;
}
- (UITableView*)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - cellHeight * self.dataList.count, CGRectGetWidth(self.frame), cellHeight * self.dataList.count + topOffset) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:groupCell bundle:nil] forCellReuseIdentifier:groupCell];
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), topOffset)];
        headerView.backgroundColor = RGB(240, 240, 240);
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(240, 240, 240);
        _tableView.separatorColor = RGB(240, 240, 240);
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

@end
