//
//  UserContractsParam.m
//  Partner
//
//  Created by  rjt on 15/11/18.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "UserContractsParam.h"
#import "ContractsEntity.h"

@implementation UserContractsParam
- (NSString *)getMethod{
    return kMethodGet;
}

- (NSString *)getOperatorType
{
    return @"/users/contracts";
}

- (Class)getEntityClass
{
    return [ContractsEntity class];
}

-(NSString *)getAliasName{
    return @"Contracts";
}
@end
