//
//  ISOrderTableViewCell.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/10.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderTableViewCell.h"
#import "ISOrderDetailModel.h"
#import "ISOrderViewModel.h"
#import "ISProductDataModel.h"

@interface ISOrderTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *presentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tejiaLabel;
@property (nonatomic, strong) ISOrderDetailModel * orderDetailModel;
@property (nonatomic, strong) ISOrderViewModel * orderViewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *presentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tejiaWidth;
@end

@implementation ISOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productNameLabel.textColor = [UIColor darkGrayColor];
    self.remarkLabel.text = @"";
    self.presentLabel.text = @"";
    self.presentLabel.backgroundColor = TheameColor;
    self.subTotalLabel.textColor = TheameColor;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
}

- (void)configureWithData:(id)data indexPath:(NSIndexPath *)indexPath superView:(UITableView *)superView{
    if (![data isKindOfClass:[ISOrderDetailModel class]]) {
        return;
    }
    
    self.orderDetailModel = data;
    self.productNameLabel.text = [[self.orderViewModel fetchProductModelById:self.orderDetailModel.ProId] ProName];
    self.unitLabel.text = [NSString stringWithFormat:@"单位: %@",self.orderDetailModel.ProUnite];
    self.amountLabel.text = [NSString stringWithFormat:@"数量: %@",self.orderDetailModel.ProQuantity];
    self.priceLabel.text = [NSString stringWithFormat:@"单价: %@",self.orderDetailModel.Amt];
    self.subTotalLabel.text = [NSString stringWithFormat:@"金额: %.2f",[self.orderDetailModel.Amt floatValue] * [self.orderDetailModel.ProQuantity floatValue]];
    
    if (![self.orderDetailModel.Remark IS_isEmptyObject]) {
        self.remarkLabel.text = [NSString stringWithFormat:@"(备注: %@)",self.orderDetailModel.Remark];
    }else{
        self.remarkLabel.text = @"";
    }
    
    if ([self.orderDetailModel.tejia isEqualToString:@"1"]) {
        self.tejiaLabel.hidden = NO;
        self.tejiaWidth.constant = 22;
    }else{
        self.tejiaLabel.hidden = YES;
        self.tejiaWidth.constant = 0;
    }
    
    if (![self.orderDetailModel.LargessQty IS_isEmptyObject]) {
        self.presentLabel.hidden = NO;
        self.presentLabel.text = [NSString stringWithFormat:@"赠送%@%@",self.orderDetailModel.LargessQty,self.orderDetailModel.LargessUnite];
        self.presentWidth.constant = [self.presentLabel.text sizeWithAttributes:@{NSFontAttributeName:Lantinghei(9)}].width + 5;
    }else{
        self.presentLabel.hidden = YES;
    }
}

- (IBAction)deleteItem:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kISOrderDeleteNotification object:nil userInfo:@{@"model":self.orderDetailModel}];
    });
}

#pragma mark - property

- (ISOrderViewModel*)orderViewModel{
    if (_orderViewModel == nil) {
        _orderViewModel = [ISOrderViewModel new];
    }
    return _orderViewModel;
}

@end
