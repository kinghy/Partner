//
//  LoginViewController.m
//  Partner
//
//  Created by  rjt on 15/11/5.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "IndexViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    UIColor *color = kColorLogin;
    self.usernameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入用户名" attributes:@{NSForegroundColorAttributeName: color}];
    self.pwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.loginBtn.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(Class)typeOfModel{
    return [LoginViewModel class];
}

-(void)bindViewModel{
    if (_viewModel) {
        LoginViewModel* model = (LoginViewModel*)_viewModel;
        RAC(model,usernameStr) = self.usernameText.rac_textSignal;
        RAC(model,pwdStr) = self.pwdText.rac_textSignal;
        self.loginBtn.rac_command = model.loginCmd;
        
        //监视点击事件结果
        __block MBProgressHUD* hud = nil;
        
        [self.loginBtn.rac_command.executionSignals subscribeNext:^(id x) {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }];
        
        @weakify(self)
        [self.loginBtn.rac_command.errors subscribeNext:^(NSError *error) {
            @strongify(self)
            [hud hide:YES];
            [EFCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:RACMsgFormError(error) withBackColor:kColorLogin];
        }];
        
        [[self.loginBtn.rac_command.executionSignals flatten] subscribeNext:^(id x) {
            @strongify(self)
            DDLogInfo(@"登录成功");
            [self.navigationController pushViewController:[[IndexViewController alloc] init] animated:YES];
        }];
    }
}
@end
