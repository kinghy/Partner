//
//  EFSource.h
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EFSourceItem.h"

@interface EFSource : NSObject
+(instancetype)source;
/*!
 *  @brief  添加或更新Group 并用Entity实例绑定section
 *
 *  @param entity       group entity实例
 *  @param sectionClass Section类
 *  @param group        分组名称，同分组拥有表头和表位
 */
-(void)setGroupEntity:(EFEntity*)entity withSection:(Class)sectionClass andHeight:(CGFloat)height andGroupName:(NSString*)group;


/*!
 *  @brief  添加Entity实例绑定section
 *
 *  @param entity       entity实例
 *  @param sectionClass Section类
 *  @param group        分组名称，同分组拥有表头和表位
 */
-(void)addEntity:(EFEntity*)entity withSection:(Class)sectionClass andGroup:(NSString*)group;

/*!
 *  @brief  添加Entity实例绑定section
 *
 *  @param entity       entity实例
 *  @param sectionClass Section类
 *  @param height       Section类的高度，传入0则不做改动
 *  @param group        分组名称，同分组拥有表头和表位
 */
-(void)addEntity:(EFEntity*)entity withSection:(Class)sectionClass andHeight:(CGFloat)height andGroup:(NSString*)group;

/*!
 *  @brief  添加Entity实例绑定section，使用默认分组
 *
 *  @param entity       entity实例
 *  @param sectionClass Section类
 */
-(void)addEntity:(EFEntity*)entity withSection:(Class)sectionClass;

/*!
 *  @brief  添加Entity实例绑定section，使用默认分组
 *
 *  @param entity       entity实例
 *  @param sectionClass Section类
 *  @param height       Section类的高度，传入0则不做改动,传入
 */
-(void)addEntity:(EFEntity*)entity withSection:(Class)sectionClass andHeight:(CGFloat)height;


/*!
 *  @brief  获取group数目，一个Group为一个分组
 *
 *  @return group数量
 */
-(NSInteger)groupCount;

/*!
 *  @brief  获取指定分组下得section实例个数
 *
 *  @param group 分组名
 *
 *  @return 返回section数量
 */
-(NSInteger)sectionCountByGroupIndex:(NSInteger)groupIndex;

/*!
 *  @brief  获取指定分组下得section实例个数
 *
 *  @param  group 分组索引数
 *
 *  @return 返回section数量
 */
-(NSInteger)sectionCountByGroup:(NSString*)group;

-(EFSourceItem*)secionByEntityIndex:(NSInteger)sectionIndex andGroupIndex:(NSInteger)groupIndex;

-(EFSourceGroupItem*)groupSecionByIndex:(NSInteger)groupIndex;


/*!
 *  @brief 移除所有分组下同类型的Section 和 Entity
 *
 *  @param cls 需要移除的类型
 */
-(void)removeSectionByClass:(Class)cls;

/*!
 *  @brief 移除所有分组下同类型的Section 和 Entity
 *
 *  @param tag 需要移除的tag
 */
-(void)removeSectionByTag:(int)tag;

/*!
 *  @brief 移除指定分组下同类型的Section 和 Entity
 *
 *  @param groupName 分组名称
 */
-(void)removeSectionByGroupName:(NSString*)groupName;

/*!
 *:  @brief  获取所有的items，不区分组
 *
 *  @return 所有的EFSourceItem实例
 */
-(NSArray*)allItems;

/*!
 *  @brief  清空
 */
-(void)clear;

@property(strong,nonatomic) NSMutableDictionary * groupDict;
@property(strong,nonatomic) NSMutableArray* groups;
@end
