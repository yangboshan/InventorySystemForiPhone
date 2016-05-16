//
//  ISPickerView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/16.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISPickerView.h"

@interface ISPickerView()
@property (nonatomic, strong) UIPickerView * picker;
@property (nonatomic, strong) UIView * toolBar;
@property (nonatomic, strong) UIView * pickerContainer;
@property (nonatomic, copy)   ISPickerViewBlock block;
@property (nonatomic, strong) NSArray * dataSource;
@end

static float toolBarHeight = 44;
static float pickerHeight = 150;


@implementation ISPickerView

- (instancetype)initPickerDataSource:(NSArray*)dataSource block:(ISPickerViewBlock)block{
    
    if (self = [super init]) {
        
        self.block = block;
        self.dataSource = dataSource;

        [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.pickerContainer];
    }
    return self;
}

-(void)didMoveToSuperview{
    [UIView transitionWithView:self.pickerContainer duration:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setBackgroundColor:MaskColor];
        self.pickerContainer.frame = CGRectMake(0, ScreenHeight - toolBarHeight - pickerHeight, ScreenWidth, toolBarHeight + pickerHeight);
    } completion:nil];
}

#pragma mark - UIPickerView delegate & datasource

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return ScreenWidth;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.dataSource.count;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        pickerLabel = [UILabel new];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [pickerLabel setFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    }
    pickerLabel.text = self.dataSource[row];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

#pragma mark - event

-(void)hide:(UIGestureRecognizer*)gesture{
    [self hideDatePickerView];
}

-(void)hideDatePickerView{
    [UIView transitionWithView:self.pickerContainer duration:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pickerContainer.frame = CGRectMake(0, ScreenHeight, ScreenWidth, toolBarHeight + pickerHeight);
        [self setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)confirmTouched:(UIButton*)sender{
    self.block(self.dataSource[[self.picker selectedRowInComponent:0]]);
    [self hideDatePickerView];
}

-(void)cancelTouched:(UIButton*)sender{
    [self hideDatePickerView];
}

#pragma mark - property

-(UIPickerView*)picker{
    
    if (!_picker) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBarHeight + 20.0, ScreenWidth, pickerHeight)];
        [_picker setDelegate:self];
        [_picker setDataSource:self];
    }
    return _picker;
}

-(UIView*)pickerContainer{
    
    if (!_pickerContainer) {
        _pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, pickerHeight + toolBarHeight)];
        [_pickerContainer setBackgroundColor:[UIColor whiteColor]];
        [_pickerContainer addSubview:self.toolBar];
        [_pickerContainer addSubview:self.picker];
    }
    return _pickerContainer;
}

-(UIView*)toolBar{
    
    if (!_toolBar) {
        
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, toolBarHeight)];
        [_toolBar setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
        
        UIButton* confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-60, 0, 60, 44)];
        UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(8 , 0, 54, 44)];

        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];

        [confirmBtn addTarget:self action:@selector(confirmTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn  addTarget:self action:@selector(cancelTouched:)  forControlEvents:UIControlEventTouchUpInside];
        
        [_toolBar addSubview:confirmBtn];
        [_toolBar addSubview:cancelBtn];
    }
    return _toolBar;
}

@end
