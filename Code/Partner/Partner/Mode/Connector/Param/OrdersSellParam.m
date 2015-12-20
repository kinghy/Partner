//
//  OrdersSellParam.m
//  Partner
//
//  Created by  rjt on 15/11/25.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "OrdersSellParam.h"
#import "OrdersSellEntity.h"

@implementation OrdersSellParam
- (NSString *)getMethod{
    return kMethodPost;
}

- (NSString *)getOperatorType{
    return @"/users/contracts/1024/orders/sell";
}

- (Class)getEntityClass{
    return [OrdersSellEntity class];
}
@end
