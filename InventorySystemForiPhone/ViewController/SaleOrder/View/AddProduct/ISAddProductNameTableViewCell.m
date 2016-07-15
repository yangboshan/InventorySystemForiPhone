//
//  ISAddProductNameTableViewCell.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/13.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISAddProductNameTableViewCell.h"
#import "ISSearchFieldViewController.h"
#import "ISProductDataModel.h"
#import "ISOrderViewModel.h"
#import "ISPickerView.h"
#import "ISMainPageViewModel.h"

@interface ISAddProductNameTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (nonatomic, strong) NSMutableDictionary * sourceFields;
@property (nonatomic, strong) NSString * field;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) ISOrderViewModel * orderViewModel;
@property (nonatomic, strong) ISMainPageViewModel * mainModel;
@end

@implementation ISAddProductNameTableViewCell

#pragma mark - lifeCycle

- (void)awakeFromNib {
    
    self.infoLabel.font = LantingheiBoldD(13);
    self.infoLabel.textColor = [UIColor grayColor];
    self.valueTextField.font = self.infoLabel.font;
    [self.valueTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.valueTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - config
- (void)configureWithData:(id)data indexPath:(NSIndexPath *)indexPath superView:(UITableView *)superView{
    
    if (![data isKindOfClass:[NSDictionary class]]) { return;}
    self.tableView = superView;
    
    NSDictionary * d = data;
    self.infoLabel.text = d[@"info"];
    self.sourceFields = d[@"model"];
    self.field = d[@"field"];
    self.valueTextField.text = self.sourceFields[self.field];
    self.valueTextField.textColor = [UIColor darkGrayColor];
    self.valueTextField.keyboardType = UIKeyboardTypeDefault;
    self.valueTextField.hidden = NO;
    
    [self setupTextField];
    [self setupCheckBox];
}

#pragma mark - methods

- (void)setupCheckBox{
    [[self.contentView viewWithTag:-99] removeFromSuperview];
    if ([self.field isEqualToString:@"tejia"]) {
        UIImageView * checkView  = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.valueTextField.frame),
                                                                                 CGRectGetCenter(self.valueTextField.frame).y - 17/2.0,
                                                                                 17,
                                                                                 17)];
        checkView.image = [UIImage imageNamed:[self.sourceFields[@"tejia"] isEqualToString:@"1"] ? @"checkbox_checked" : @"checkbox_unchecked"];
        checkView.tag = -99;
        checkView.tintColor = TheameColor;
        [self.contentView addSubview:checkView];
    }
}

- (void)setupTextField{
    if ([self.field isEqualToString:@"N_MingCheng"]) {
        self.valueTextField.placeholder = @"商品的名称";
        self.valueTextField.enabled = NO;
    }
    if ([self.field isEqualToString:@"ProUnite"]) {
        self.valueTextField.placeholder = @"单位";
        self.valueTextField.enabled = NO;
    }
    if ([self.field isEqualToString:@"ProQuantity"]) {
        self.valueTextField.placeholder = @"数量";
        self.valueTextField.enabled = YES;
        self.valueTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    if ([self.field isEqualToString:@"Amt"]) {
        self.valueTextField.placeholder = @"单价";
        self.valueTextField.enabled = self.mainModel.hasPrivilegeForModifyPrice ? YES : NO;
        self.valueTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    if ([self.field isEqualToString:@"N_JinE"]) {
        self.valueTextField.placeholder = @"金额";
        self.valueTextField.enabled = NO;
    }
    if ([self.field isEqualToString:@"N_GuiGe"]) {
        self.valueTextField.placeholder = @"规格";
        self.valueTextField.enabled = NO;
    }
    
    if ([self.field isEqualToString:@"N_KuCun"]) {
        self.valueTextField.placeholder = @"库存";
        self.valueTextField.enabled = NO;
        
        if (![self.sourceFields[self.field] IS_isEmptyObject]) {
            float inv = [self.sourceFields[self.field] floatValue];
            if (inv < 0) {
                self.valueTextField.textColor = [UIColor redColor];
            }
        }
    }
    
    if ([self.field isEqualToString:@"N_TiShi"]) {
        self.valueTextField.placeholder = @"提示";
        self.valueTextField.enabled = NO;
    }
    if ([self.field isEqualToString:@"tejia"]) {
        self.valueTextField.placeholder = @"";
        self.valueTextField.enabled = NO;
        self.valueTextField.hidden = YES;
    }
    if ([self.field isEqualToString:@"LargessQty"]) {
        self.valueTextField.placeholder = @"赠送数量";
        self.valueTextField.enabled = YES;
        self.valueTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    if ([self.field isEqualToString:@"LargessUnite"]) {
        self.valueTextField.placeholder = @"赠送单位";
        self.valueTextField.enabled = NO;
    }
    if ([self.field isEqualToString:@"Remark"]) {
        self.valueTextField.placeholder = @"备注";
        self.valueTextField.enabled = YES;
    }
}

- (void)userTapped:(UIGestureRecognizer*)gesture{
    
    __weak typeof(self) weakSelf = self;
    if ([self.field isEqualToString:@"N_MingCheng"]) {
        ISSearchFieldViewController * searchController = [[ISSearchFieldViewController alloc] initWithType:ISSearchFieldTypeProduct finish:^(ISProductDataModel * model) {
            [weakSelf.sourceFields setValue:model.ProName forKey:self.field];
            [weakSelf.sourceFields setValue:model.ProId forKey:@"ProId"];
            
            
            [weakSelf.sourceFields setValue:@"" forKey:@"ProUnite"];
            NSString * unit = [[weakSelf.orderViewModel fetchUnitByProductId:model.ProId smallUnit:[[[weakSelf viewController] valueForKey:@"smallUnit"] boolValue]] firstObject];
            if (unit) {
               [weakSelf.sourceFields setValue:[[weakSelf.orderViewModel fetchUnitByProductId:model.ProId smallUnit:[[[weakSelf viewController] valueForKey:@"smallUnit"] boolValue]] firstObject] forKey:@"ProUnite"];
            }
            
            
            [weakSelf.sourceFields setValue:model.Type forKey:@"N_GuiGe"];
            [weakSelf.sourceFields setValue:@"" forKey:@"Amt"];
            [weakSelf.sourceFields setValue:@"" forKey:@"N_KuCun"];
            [weakSelf.sourceFields setValue:@"" forKey:@"N_TiShi"];
            [weakSelf.sourceFields setValue:@"" forKey:@"N_JinE"];
            
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kISOrderRefreshNotification object:nil];
            });
        }];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:searchController];
        [[self viewController].navigationController presentViewController:navController animated:YES completion:nil];
    }
    
    if ([self.field isEqualToString:@"ProUnite"] || [self.field isEqualToString:@"LargessUnite"]) {
        if ([self.sourceFields[@"ProId"] IS_isEmptyObject]) {
            return;
        }
        ISPickerView * pickerView = [[ISPickerView alloc] initPickerDataSource:[self.orderViewModel fetchUnitByProductId:self.sourceFields[@"ProId"] smallUnit:YES] block:^(id data) {
            [weakSelf.sourceFields setValue:data forKey:self.field];
            if ([self.field isEqualToString:@"ProUnite"]) {
                [weakSelf.sourceFields setValue:@"" forKey:@"Amt"];
                [weakSelf.sourceFields setValue:@"" forKey:@"N_KuCun"];
                [weakSelf.sourceFields setValue:@"" forKey:@"N_TiShi"];
                [weakSelf.sourceFields setValue:@"" forKey:@"N_JinE"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kISOrderRefreshNotification object:nil];
                });
            }
            [weakSelf.tableView reloadData];
        }];
        [[self viewController].view addSubview:pickerView];
    }
    
    if ([self.field isEqualToString:@"tejia"]) {
        if ([self.sourceFields[self.field] isEqualToString:@"1"]) {
            [self.sourceFields setValue:@"0" forKey:self.field];
        }else{
            [self.sourceFields setValue:@"1" forKey:self.field];
        }
        [self.tableView reloadData];
    }
}

- (void)textFieldDidEndEditing:(id)sender{
    [self.tableView reloadData];
}

- (void)textFieldValueChanged:(id)sender{
    
    [self.sourceFields setValue:[self.valueTextField.text trim] forKey:self.field];
    
    if ([self.field isEqualToString:@"ProQuantity"] || [self.field isEqualToString:@"Amt"]){
        if (self.valueTextField.text.length) {
            if (![self.sourceFields[@"Amt"] IS_isEmptyObject]) {
                self.sourceFields[@"N_JinE"] = [NSString stringWithFormat:@"%.2f", [self.sourceFields[@"Amt"] floatValue] * [self.sourceFields[@"ProQuantity"] floatValue]];
            }
        }
    }
}

#pragma mark - property

- (ISMainPageViewModel*)mainModel{
    if(_mainModel == nil){
        _mainModel = [ISMainPageViewModel new];
    }
    return _mainModel;
}

- (ISOrderViewModel*)orderViewModel{
    if (_orderViewModel == nil) {
        _orderViewModel = [[ISOrderViewModel alloc] init];
    }
    return _orderViewModel;
}

@end
