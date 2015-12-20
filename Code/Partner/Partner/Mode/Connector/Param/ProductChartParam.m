//
//  ProductChartMock.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductChartParam.h"


@implementation ProductChartParam

- (NSString *)sendMethod {
    return @"GET";
}


- (NSString *)getOperatorType
{
    return @"chartInterface";
}


- (Class)getEntityClass
{
    return [ProductChartEntity class];
}

@end
