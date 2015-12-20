//
//  ProductHqsMock.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductHqsParam.h"
#import "ProductHqsEntity.h"

@implementation ProductHqsParam

- (NSString *)sendMethod {
    return @"GET";
}

- (NSString *)getOperatorType
{
    return @"hqInterface";
}

- (Class)getEntityClass
{
    return [ProductHqsEntity class];
}

-(NSString *)getAliasName{
    return @"ProductHqs";
}

@end
