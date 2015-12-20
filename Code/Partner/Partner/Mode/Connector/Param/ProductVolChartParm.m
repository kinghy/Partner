//
//  ProductVolChartMock.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductVolChartParm.h"

@implementation ProductVolChartParam

- (NSString *)sendMethod {
    return @"GET";
}

- (NSString *)getOperatorType
{
    return @"volchartInterface";
}

- (Class)getEntityClass
{
    return [ProductVolChartEntity class];
}

@end
