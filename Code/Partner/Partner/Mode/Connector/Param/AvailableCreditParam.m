//
//  AvailableCreditParam.m
//  Partner
//
//  Created by  rjt on 15/11/19.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AvailableCreditParam.h"
#import "AvailableCreditEntity.h"

@implementation AvailableCreditParam

- (NSString *)getMethod{
    return kMethodGet;
}

- (NSString *)getOperatorType{
    return @"/users/contracts/1024/availableCredit";
}

- (Class)getEntityClass{
    return [AvailableCreditEntity class];
}


@end
