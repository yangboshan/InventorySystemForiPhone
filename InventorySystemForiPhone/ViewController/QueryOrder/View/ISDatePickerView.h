//
//  ISDatePickerView.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/20.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ISDatePickerViewBlock)(NSString * date);

@interface ISDatePickerView : UIView

- (instancetype)initPickerWithBlock:(ISDatePickerViewBlock)block;


@end
