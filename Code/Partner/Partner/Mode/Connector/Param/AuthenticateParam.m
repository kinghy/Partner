//
//  LoginParam.m
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AuthenticateParam.h"
#import "AuthenticateEntity.h"

@implementation AuthenticateParam
- (NSString *)getMethod{
    return kMethodPost;
}

- (NSString *)getOperatorType
{
    return @"/authenticate";
}

- (Class)getEntityClass
{
    return [AuthenticateEntity class];
}
@end
