//
//  BCBaseTableViewCell.m
//  TripAway
//
//  Created by yangboshan on 15/2/4.
//  Copyright (c) 2015年 bcinfo. All rights reserved.
//

#import "ISBaseTableViewCell.h"

@interface ISBaseTableViewCell ()
@end

@implementation ISBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
}


@end
