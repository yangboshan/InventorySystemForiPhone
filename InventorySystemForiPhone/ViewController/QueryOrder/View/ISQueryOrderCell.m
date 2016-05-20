//
//  ISQueryOrderCell.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/20.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISQueryOrderCell.h"
#import "ISOrderDataModel.h"

@interface ISQueryOrderCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (nonatomic, strong) ISOrderDataModel * orderModel;

@end
@implementation ISQueryOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderNoLabel.font = LantingheiBoldD(12);
    self.statusLabel.font = Lantinghei(9);
    self.customerLabel.font = LantingheiD(13);
    self.totalLabel.font = LantingheiBoldD(13);
    self.totalLabel.textColor = TheameColor;
    self.remarkLabel.font = LantingheiD(10);
    self.remarkLabel.textColor = [UIColor lightGrayColor];
    self.orderNoLabel.textColor = [UIColor grayColor];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.layer.cornerRadius = 2.0;
    self.statusLabel.clipsToBounds = YES;
}

- (void)configureWithData:(id)data indexPath:(NSIndexPath *)indexPath superView:(UITableView *)superView{
    self.orderModel = data;
    
    self.orderNoLabel.text = self.orderModel.SwapCode;
    self.statusLabel.text = [self.orderModel.Status isEqualToString:@"1"] ? @"已上传" : @"未上传";
    self.statusLabel.backgroundColor = [self.orderModel.Status isEqualToString:@"1"] ? TheameColor : [UIColor orangeColor];
    self.customerLabel.text = [NSString stringWithFormat:@"客户: %@",self.orderModel.PartnerName];
    self.totalLabel.text = [NSString stringWithFormat:@"金额: %@",self.orderModel.sumAmt];
    if (![self.orderModel.Remark IS_isEmptyObject]) {
        self.remarkLabel.text = [NSString stringWithFormat:@"备注: %@",self.orderModel.Remark];
    }else{
        self.remarkLabel.text = @"";
    }
}

- (IBAction)deleteItem:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kISOrderDataDeleteNotification object:nil userInfo:@{@"model":self.orderModel}];
    });
}

@end
