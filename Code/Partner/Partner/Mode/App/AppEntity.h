//
//  AppEntity.h
//  EasyFrame
//
//  Created by  rjt on 15/6/17.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#import "EFEntity.h"

@interface AppEntity : EFEntity
@property(strong,nonatomic)NSString* code;
@property(strong,nonatomic)NSString* message;

/*!
 *  @brief  Entity是否有效
 *
 *  @param entity AppEntity实例
 */
+(BOOL)isEntityValid:(EFEntity*)entity;
@end
