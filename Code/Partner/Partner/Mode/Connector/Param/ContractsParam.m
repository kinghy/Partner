//
//  ContractsParam.m
//  Partner
//
//  Created by  rjt on 15/11/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "ContractsParam.h"
#import "ContractsEntity.h"

@implementation ContractsParam
- (NSString *)getMethod{
    return kMethodGet;
}

- (NSString *)getOperatorType
{
    return @"/contracts";
}

- (Class)getEntityClass
{
    return [ContractsEntity class];
}

-(NSString *)getAliasName{
    return @"Contracts";
}
@end
