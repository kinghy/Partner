/*!
 @header EFBaseManager.h
 @abstract 定义Manager基类
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */

#import <Foundation/Foundation.h>
@class EFEntity;
typedef void (^EFManagerRetBlock)(EFEntity* entity,NSError *error);
@interface EFBaseManager : NSObject

@end
