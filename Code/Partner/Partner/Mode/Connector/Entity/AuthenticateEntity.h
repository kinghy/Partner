//
//  AuthenticateEntity.h
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AppEntity.h"

@interface AuthenticateEntity : AppEntity
@property (strong, nonatomic)  NSString *value;
@property (strong, nonatomic)  NSString *expiresIn;
@end
