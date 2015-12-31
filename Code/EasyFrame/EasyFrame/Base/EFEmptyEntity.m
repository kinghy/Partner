//
//  EFEmptyEntity.m
//  EasyFrame
//
//  Created by  rjt on 15/12/21.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFEmptyEntity.h"

@implementation EFEmptyEntity
-(instancetype)init{
    if (self = [super init]) {
        _indentationLevel = 0;
        _indentationWidth = 10.0f;
    }
    return self;
}
@end
