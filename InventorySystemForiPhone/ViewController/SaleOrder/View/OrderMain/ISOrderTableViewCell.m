//
//  ISOrderTableViewCell.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderTableViewCell.h"

@interface ISOrderTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *presentLabel;
@end

@implementation ISOrderTableViewCell

- (void)awakeFromNib {
    
    self.productNameLabel.textColor = [UIColor darkGrayColor];
    
    self.heightConstraint.constant = 0.5;
    self.remarkLabel.text = @"";
    self.presentLabel.text = @"";
}


@end
