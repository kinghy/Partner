//
//  LoginParam.h
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AppParam.h"

@interface AuthenticateParam : AppParam
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@end
