//
//  ProductPanKouEntity.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductPanKouEntity.h"

@implementation ProductPanKouEntity
//接口返回百元为单位，实际显示万元为单位
-(NSString *)amount{
    NSInteger a =  [_amount floatValue]/100;
    return [NSString stringWithFormat:@"%ld",(long)a ];
}

-(void)setStockcode:(NSString *)stockcode{
    if (stockcode && [stockcode isEqualToString:@"999999"]) {
        stockcode = @"sh.999999";
    }
    _stockcode = stockcode;
}

@end
