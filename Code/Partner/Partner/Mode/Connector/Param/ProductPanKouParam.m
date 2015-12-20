//
//  ProductPanKouMock.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductPanKouParam.h"
#import "ProductPanKouEntity.h"

@implementation ProductPanKouParam

- (NSString *)sendMethod {
    return @"GET";
}

- (NSString *)getOperatorType
{
    return @"pankouInterface";
}

- (Class)getEntityClass
{
    return [ProductPanKouEntity class];
}

@end
