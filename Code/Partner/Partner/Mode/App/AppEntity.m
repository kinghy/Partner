//
//  AppEntity.m
//  EasyFrame
//
//  Created by  rjt on 15/6/17.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#import "AppEntity.h"

@implementation AppEntity
//-(NSString *)code{
//    return [NSString stringWithFormat:@"%@",_code];
//}


+(BOOL)isEntityValid:(EFEntity *)entity{
    if([entity isKindOfClass:[AppEntity class]]){
        AppEntity * e= (AppEntity*)entity;
        if (e.code==nil) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
@end
