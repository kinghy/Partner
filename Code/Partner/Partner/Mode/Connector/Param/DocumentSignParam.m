//
//  DocumentSignParam.m
//  Partner
//
//  Created by  rjt on 15/11/5.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "DocumentSignParam.h"
#import "DocumentEntity.h"
#import "DocumentSignEntity.h"

@implementation DocumentSignParam
- (NSString *)getMethod{
    return kMethodPost;
}

- (NSString *)getOperatorType
{
    return @"/users/contracts/2/sign";
}

- (Class)getEntityClass
{
    return [DocumentSignEntity class];
}

@end
