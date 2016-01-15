//
//  LoginViewModel.m
//  Partner
//
//  Created by  rjt on 15/12/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginViewModel.h"

@implementation LoginViewModel
-(void)viewModelDidLoad{
    DEFINED_WEAK_SELF;
    UIBlurEffect *effect;
    self.loginCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            self.usernameStr = @"michaelkira";
            self.pwdStr = @"311622";
            if (_self.usernameStr.length==0) {
                [subscriber sendError:RACErrorFromMsg(@"请输入用户名")];
            }else if (_self.pwdStr.length==0) {
                [subscriber sendError:RACErrorFromMsg(@"请输入密码")];
            }else {
                [[UserManager shareUserManager] loginWithName:_self.usernameStr andPwd:_self.pwdStr andBlock:^(EFEntity *entity, NSError *error) {
                    if (error==nil &&  [AppEntity isEntityValid:entity] ) {
                        [subscriber sendNext:@(YES)];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:error];
                    }
                }];
                
            }
            return nil;
        }];
        
    }];
    
}
@end
