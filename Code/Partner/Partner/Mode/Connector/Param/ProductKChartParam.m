//
//  ProductKChartParam.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductKChartParam.h"

@implementation ProductKChartParam


- (NSString *)sendMethod {
    return @"GET";
}

- (NSString *)days {
    return @"120";
}


- (NSString *)getOperatorType
{
    return @"kChartInterface";
}

- (Class)getEntityClass
{
    return [ProductKChartEntity class];
}

- (NSString *)getAliasName {
    return @"ProductKChart";
}

@end
