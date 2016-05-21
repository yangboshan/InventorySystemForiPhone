//
//  ISSettingTableViewCell.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/21.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSettingTableViewCell.h"

@interface ISSettingTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

@implementation ISSettingTableViewCell

- (void)awakeFromNib {
    self.titleLabel.font = LantingheiD(14);
    self.infoLabel.font = LantingheiD(13);
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.infoLabel.textColor = [UIColor lightGrayColor];
}

- (void)configureWithData:(id)data indexPath:(NSIndexPath *)indexPath superView:(UITableView *)superView{
    NSDictionary * d = data;
    self.titleLabel.text = d[@"title"];
    self.infoLabel.text = d[@"info"];
}



@end
