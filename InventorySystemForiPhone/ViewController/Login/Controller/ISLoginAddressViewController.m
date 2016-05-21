//
//  ISLoginAddressViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/21.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISLoginAddressViewController.h"

@interface ISLoginAddressViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@end

@implementation ISLoginAddressViewController

#pragma mark -  lifeCycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup{
    [self.view setBackgroundColor:RGB(243, 244, 245)];
    self.bgView.layer.borderColor = BorderColor;
    self.bgView.layer.borderWidth = 0.7;
    self.addressTextField.text = [ISSettingManager sharedInstance].serviceUrl;
    [self.addressTextField addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)editingDidEnd:(id)sender{
    [ISSettingManager sharedInstance].serviceUrl = self.addressTextField.text;
}

@end
