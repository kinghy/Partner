//
//  OrdersBuyParam.m
//  Partner
//
//  Created by  rjt on 15/11/19.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "OrdersBuyParam.h"
#import "OrdersBuyEntity.h"

@implementation OrdersBuyParam
- (NSString *)getMethod{
    return kMethodPost;
}

- (NSString *)getOperatorType{
    return @"/users/contracts/1024/orders/buy";
}

- (Class)getEntityClass{
    return [OrdersBuyEntity class];
}

@end
