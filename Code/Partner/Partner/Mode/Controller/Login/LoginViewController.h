//
//  LoginViewController.h
//  Partner
//
//  Created by  rjt on 15/11/5.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

@class LoginViewModel;

@interface LoginViewController : EFBaseViewController

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end
