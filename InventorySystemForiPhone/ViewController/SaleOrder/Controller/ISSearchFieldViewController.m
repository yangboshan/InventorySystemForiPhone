//
//  ISSearchFieldViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSearchFieldViewController.h"

@interface ISSearchFieldViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, assign) ISSearchFieldType type;
@property (nonatomic, copy) ISSearchFieldBlock block;
@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataList;
@end

static NSString * cellId = @"cellId";

@implementation ISSearchFieldViewController

#pragma mark - life Cycle

- (instancetype)initWithType:(ISSearchFieldType)type finish:(ISSearchFieldBlock)block{
    if (self = [super init]) {
        self.type = type;
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    [self.view addSubview:self.tableView];
    [self autolayoutSubView];
    self.navigationItem.titleView = self.searchBar;
}

- (void)autolayoutSubView{
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.font = Lantinghei(14);
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

#pragma mark - UISearchBarDelgate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (![NSString stringIsNilOrEmpty:searchBar.text]) {
        if (self.block) {
            self.block(searchBar.text);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - property

- (UITableView*)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UISearchBar*)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 0, ScreenWidth - 100, 30)];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
    }
    return _searchBar;
}


@end
