//
//  LoginViewModel.h
//  Partner
//
//  Created by  rjt on 15/12/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface LoginViewModel : EFBaseViewModel
@property (nonatomic,strong) NSString* usernameStr;
@property (nonatomic,strong) NSString* pwdStr;
@property (nonatomic,strong) RACCommand* loginCmd;
@end
