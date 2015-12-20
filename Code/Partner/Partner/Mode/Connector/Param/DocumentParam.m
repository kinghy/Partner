//
//  DocumentParam.m
//  Partner
//
//  Created by  rjt on 15/11/5.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "DocumentParam.h"
#import "DocumentEntity.h"

@implementation DocumentParam
- (NSString *)getMethod{
    return kMethodGet;
}

- (NSString *)getOperatorType
{
    return @"/users/contracts/2/generateDocument";
}

- (Class)getEntityClass
{
    return [DocumentEntity class];
}

@end
