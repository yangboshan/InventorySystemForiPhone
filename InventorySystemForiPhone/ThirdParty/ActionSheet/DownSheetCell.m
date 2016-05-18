//
//  DownSheetCell.m
//  audioWriting
//
//  Created by wolf on 14-7-19.
//  Copyright (c) 2014年 wangruiyy. All rights reserved.
//

#import "DownSheetCell.h"

@implementation DownSheetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        leftView = [[UIImageView alloc]init];
        InfoLabel = [[UILabel alloc]init];
        InfoLabel.font = LantingheiBoldD(14);
        InfoLabel.textColor = [UIColor darkGrayColor];
        InfoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:InfoLabel];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    InfoLabel.frame = CGRectMake(0, (self.frame.size.height-20)/2, ScreenWidth, 20);
    InfoLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setData:(NSString *)data{
    InfoLabel.text = data;
}

@end
