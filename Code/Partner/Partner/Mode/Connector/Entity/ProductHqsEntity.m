//
//  ProductHqsEntity.m
//  Partner
//
//  Created by  rjt on 15/11/12.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "ProductHqsEntity.h"

@implementation ProductHqsEntity

@end

@implementation ProductHqsRecordsEntity
-(void)setStockcode:(NSString *)stockcode{
    if (stockcode && [stockcode isEqualToString:@"999999"]) {
        stockcode = kStoCodeSH;
    }
    _stockcode = stockcode;
}
@end