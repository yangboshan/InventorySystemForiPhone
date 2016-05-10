//
//  UITableViewCell+ISCategory.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ISCategory)

-(void)configureWithData:(id)data indexPath:(NSIndexPath*)indexPath superView:(UITableView*)superView;

@end
