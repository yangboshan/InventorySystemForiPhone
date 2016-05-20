//
//  ISDatePickerView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/20.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISDatePickerView.h"

@interface ISDatePickerView()
@property (nonatomic, strong) UIDatePicker * picker;
@property (nonatomic, strong) UIView * toolBar;
@property (nonatomic, strong) UIView * pickerContainer;
@property (nonatomic, copy)   ISDatePickerViewBlock block;
@end


static float toolBarHeight = 44;
static float pickerHeight  = 150;


@implementation ISDatePickerView

#pragma mark - lifeCycle

- (instancetype)initPickerWithBlock:(ISDatePickerViewBlock)block{
    
    if (self = [super init]) {
        self.block = block;
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
    if (self.block) {
        self.block([self.picker.date dateStringWithFormat:@"yyyyMMdd"]);
    }
    [self hideDatePickerView];
}

-(void)cancelTouched:(UIButton*)sender{
    [self hideDatePickerView];
}

#pragma mark - property

-(UIDatePicker*)picker{
    
    if (!_picker) {
        _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, toolBarHeight + 20.0, ScreenWidth, pickerHeight)];
        _picker.datePickerMode = UIDatePickerModeDate;
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
