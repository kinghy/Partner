/*!
 @header EFAdaptor.h
 @abstract 定义适配器基类，用于扩展EFTableView
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "EFAdaptorDelegate.h"
#import "EFNibHelper.h"
#import "EFTableView.h"
#import "EFSetEntity.h"

@class EFSource;

@interface EFAdaptor : NSObject<UITableViewDataSource,UITableViewDelegate,EFTableViewDelegate>
/*!
 *  @brief  绑定table、section和数据源
 *
 *  @param sources   数据源
 *  @param tableView table
 *  @param nibArray  section名称
 */
-(void)bindSource:(EFSource *)sources andTableView:(EFTableView *)tableView nibName:(NSString*)nibName;
/*!
 *  @brief  绑定table、section和数据源
 *
 *  @param sources   数据源
 *  @param tableView table
 *  @param nibArray  section名称数组
 */
-(void)bindSource:(EFSource *)sources andTableView:(EFTableView *)tableView nibArray:(NSArray *)nibArray;

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
 *  @brief  添加默认TableCell样式的列表
 *
 *  @param entity       EFSetEntity实例
 *  @param group        分组
 */
-(void)addSetEntity:(EFSetEntity*)entity andGroup:(NSString*)group;

/*!
 *  @brief  添加默认TableCell样式的列表
 *
 *  @param entity       EFSetEntity实例
 *  @param height       cell高度，传入0则不做改动
 *  @param group        分组
 */
-(void)addSetEntity:(EFSetEntity*)entity andHeight:(CGFloat)height andGroup:(NSString*)group;

/*!
 *  @brief  清空
 */
-(void)clear;

/*!
 *  @brief  刷新table
 */
-(void)notifyChanged;

/*!
 *  @brief  构造实例
 *
 *  @return 实例
 */
+(instancetype)adaptor;

/*!
 *  @brief  构造实例
 *
 *  @param tableView table
 *  @param array     section名称数组
 *  @param delegate  代理实例
 *
 *  @return 实例
 */
+(instancetype)adaptorWithTableView:(EFTableView *)tableView nibArray:(NSArray *)array delegate:(id<EFAdaptorDelegate>)delegate ;

@property (nonatomic) BOOL scrollEnabled;

/*!
 *  @brief  填充满父窗口开关
 */
@property (nonatomic) BOOL fillParentEnabled;

/*!
 *  @brief  设置此属性为YES，当选择section后产生的高亮背景会被立刻恢复到正常背景
 */
@property (nonatomic) BOOL selectAutoCancel;

@property(nonatomic,strong)EFSource* pSources;
@property(nonatomic,weak)EFTableView* pTableView;
@property(nonatomic,assign)id<EFAdaptorDelegate> delegate;
@property(nonatomic,strong)NSArray* pNibNameArray;
@property(nonatomic,strong)NSMutableArray* pSectionInfos;

@end
