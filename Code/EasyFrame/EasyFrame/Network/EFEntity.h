
/*!
 @header EFEntity.h
 @abstract 接口返回数据接口基类
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */
#import <Foundation/Foundation.h>
/*!
 *  @class  EFEntity
 *  @brief 接口返回数据接口基类
 */
@interface EFEntity : NSObject
/*!
 *  @brief  构建方法
 *
 *  @return 实例对象
 */
+(instancetype)entity;


/*!
 *  @brief  快捷参数列表
 */
@property (nonatomic,strong)    id dict;

@property(nonatomic,assign)     NSInteger tag;

@end
