//
//  MarketParam.m
//  Partner
//
//  Created by  rjt on 15/11/17.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "MarketParam.h"
#import "MarketEntity.h"

@implementation MarketParam
- (NSString *)getMethod{
    return kMethodGet;
}

- (NSString *)getOperatorType
{
    return @"/markets";
}

- (Class)getEntityClass
{
    return [MarketEntity class];
}

-(NSString *)getAliasName{
    return @"Market";
}
@end
