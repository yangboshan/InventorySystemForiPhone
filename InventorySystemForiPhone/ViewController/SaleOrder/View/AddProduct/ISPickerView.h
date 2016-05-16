//
//  ISPickerView.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/16.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ISPickerViewBlock)(id data);

@interface ISPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

- (instancetype)initPickerDataSource:(NSArray*)dataSource block:(ISPickerViewBlock)block;

@end
