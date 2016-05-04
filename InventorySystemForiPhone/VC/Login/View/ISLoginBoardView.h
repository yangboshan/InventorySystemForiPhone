//
//  ISLoginView.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISLoginBoardView : UIView

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end
