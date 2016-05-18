//
//  ISSpaceTableViewCell.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISSpaceTableViewCell.h"

@interface ISSpaceTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation ISSpaceTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

-(void)configureWithData:(id)data indexPath:(NSIndexPath*)indexPath superView:(UITableView*)superView{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary * param = data;
        if ([param.allKeys containsObject:@"height"]) {
            if ([param[@"height"] isKindOfClass:[NSNumber class]]) {
                self.heightConstraint.constant = [param[@"height"] floatValue];
            }else{
                NSParameterAssert(NO);
            }
        }
        if ([param.allKeys containsObject:@"bgColor"]) {
            if ([param[@"bgColor"] isKindOfClass:[UIColor class]]) {
                self.bgView.backgroundColor = param[@"bgColor"];
            }else{
                NSParameterAssert(NO);
            }
        }
    }
}


@end
