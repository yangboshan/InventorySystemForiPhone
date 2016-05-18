//
//  DownSheet.m
//  audioWriting
//
//  Created by wolf on 14-7-19.
//  Copyright (c) 2014年 wangruiyy. All rights reserved.
//

#import "DownSheet.h"


@interface DownSheet()

@property (nonatomic,copy) DownSheetBlock block;

@end

@implementation DownSheet


-(id)initWithlist:(NSArray *)list block:(DownSheetBlock)block{
    self = [super init];
    if(self){
        
        self.block = block;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = RGBACOLOR(160, 160, 160, 0);
        view = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth,44*[list count]) style:UITableViewStylePlain];
        view.dataSource = self;
        view.delegate = self;
        listData = list;
        view.scrollEnabled = NO;
        if ([view respondsToSelector:@selector(setSeparatorInset:)]) {
            [view setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([view respondsToSelector:@selector(setLayoutMargins:)]) {
            [view setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        [self addSubview:view];
        [self animeData];
    }
    return self;
}

-(void)animeData{
    //self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    [UIView animateWithDuration:.35 animations:^{
        self.backgroundColor = MaskColor;
        [UIView animateWithDuration:.35 animations:^{
            [view setFrame:CGRectMake(view.frame.origin.x, ScreenHeight-view.frame.size.height, view.frame.size.width, view.frame.size.height)];
        }];
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}

-(void)tappedCancel{
    [UIView animateWithDuration:.35 animations:^{
        [view setFrame:CGRectMake(0, ScreenHeight,ScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIViewController *)Sview
{
    if(Sview==nil){
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }else{
    //[view addSubview:self];
        [Sview.view addSubview:self];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DownSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[DownSheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setData:[listData objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tappedCancel];
    if (self.block) {
        self.block(indexPath.row);
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
