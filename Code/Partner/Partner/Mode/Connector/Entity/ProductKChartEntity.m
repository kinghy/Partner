//
//  ProductKChartEntity.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductKChartEntity.h"

@implementation ProductKChartEntity
-(void)setStockcode:(NSString *)stockcode{
    if (stockcode && [stockcode isEqualToString:@"999999"]) {
        stockcode = @"sh.999999";
    }
    _stockcode = stockcode;
}
@end
@implementation ProductKChartRecordsEntity



@end