//
//  ISOrderPhotoTableViewCell.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/13.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderPhotoTableViewCell.h"

@interface ISOrderPhotoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *inDoorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *outDoorImageView;
@end

@implementation ISOrderPhotoTableViewCell

- (void)awakeFromNib {
    self.inDoorImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.inDoorImageView.clipsToBounds = YES;
    self.outDoorImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.outDoorImageView.clipsToBounds = YES;
}

- (void)configureWithData:(id)data indexPath:(NSIndexPath *)indexPath superView:(UITableView *)superView{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary * d = data;
        if ([d.allKeys containsObject:@"in"]) {
            if (![d[@"in"] isEqual:[NSNull null]]) {
                self.inDoorImageView.image = d[@"in"];
            }
        }
        if ([d.allKeys containsObject:@"out"]) {
            if (![d[@"out"] isEqual:[NSNull null]]) {
                self.outDoorImageView.image = d[@"out"];
             }
        }
    }
}


@end
