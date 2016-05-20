//
//  ISQueryOrderHeaderView.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/20.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISQueryOrderHeaderView.h"
#import "ISDatePickerView.h"

@implementation ISQueryOrderHeaderView

- (void)awakeFromNib{
    self.customBtn.selected = YES;
    [self.customBtn setTitleColor:TheameColor forState:UIControlStateNormal];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    [self.dateLabel addGestureRecognizer:tap];
    self.dateLabel.userInteractionEnabled = YES;
    self.dateLabel.text = [[NSDate currentDate] dateStringWithFormat:@"yyyyMMdd"];

}

- (void)showDatePicker:(UIGestureRecognizer*)gesture{
    
    __weak typeof(self) weakSelf = self;
    ISDatePickerView * datePicker = [[ISDatePickerView alloc] initPickerWithBlock:^(NSString * date) {
        weakSelf.dateLabel.text =  date;
        if (weakSelf.block) {
            weakSelf.block(nil);
        }
    }];
    [[self viewController].view addSubview:datePicker];
}

@end
