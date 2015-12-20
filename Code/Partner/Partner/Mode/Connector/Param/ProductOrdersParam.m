//
//  ProductOrdersParam.m
//  Partner
//
//  Created by  rjt on 15/11/25.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "ProductOrdersParam.h"
#import "ProductOrdersEntity.h"

@implementation ProductOrdersParam
- (NSString *)getMethod{
    return kMethodGet;
}

- (NSString *)getOperatorType{
    return @"/users/contracts/1024/orders";
}

- (Class)getEntityClass{
    return [ProductOrdersEntity class];
}

-(NSString *)getAliasName{
    return @"ProductOrders";
}


@end
