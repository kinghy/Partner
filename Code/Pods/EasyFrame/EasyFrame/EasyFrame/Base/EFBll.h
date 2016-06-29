//
//  EFBll.h
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFAdaptor.h"
#import "EFBaseViewController.h"
#import "EFTableView.h"

#define kBllUniqueTable @"kBllUniqueTable"

@class EFBaseViewModel;

@interface EFBll : NSObject<EFAdaptorDelegate,EFBaseViewControllerDelegate>{
    EFBaseViewModel* _viewModel;
}

/*!
 *  @brief  构造Bll方法
 *
 *  @return 返回实例
 */
+(instancetype)bll;

/*!
 *  @brief  构造Bll方法
 *
 *  @param controller 父Controller
 *  @param tableView  table容器
 *
 *  @return 是咧
 */
//+(instancetype)bllWithController:(EFBaseViewController *)controller  tableView:(EFTableView*)tableView;

/*!
 *  @brief  构造Bll方法
 *
 *  @param controller 父Controller
 *  @param tables     tableView字典（tableview名称:实例）
 *
 *  @return 是咧
 */
+(instancetype)bllWithController:(EFBaseViewController *)controller tableViewDict:(NSDictionary *)tables;

/*!
 *  @brief  构造Bll方法
 *
 *  @param controller 父Controller
 *  @param tables     tableView字典（tableview名称:实例）
 *  @param viewModel  viewModel实例，子类需实现typeOfModel确定实例类型
 *
 *  @return 是咧
 */
+(instancetype)bllWithController:(EFBaseViewController *)controller tableViewDict:(NSDictionary *)tables viewModel:(EFBaseViewModel*)viewModel;

/*!
 *  @brief 返回ViewModel的实例，子类实现
 *
 *  @return 返回需要实例类型
 */
-(Class)typeOfModel;

/*!
 *  @brief  初始化方法，子类实现
 */
-(void)loadBll;

/*!
 *  @brief  隐藏当前Bll
 */
- (void)hide;

/*!
 *  @brief  显示当前Bll
 */
- (void)show;

/*!
 *  @brief  初始化manager
 */
- (void)loadEFManager;

/*!
 *  @brief  初始化UI，在此创建Section
 *
 *  @param tableView table
 */
- (EFAdaptor*)loadEFUIWithTable:(EFTableView*)tableView andKey:(NSString*)key;

/*!
 *  @brief  MVVM模式绑定ViewModel
 */
-(void)bindViewModel;

/*!
 *  @brief  控制器出现时调用
 */
-(void)controllerDidAppear;
/*!
 *  @brief  控制器将要出现时时调用
 */
-(void)controllerWillAppear;
/*!
 *  @brief  控制器隐藏时调用
 */
-(void)controllerDidDisappear;

/*!
 *  @brief  table容器
 */
@property(nonatomic,strong)NSMapTable* pTableDict;

/*!
 *  @brief  父控制器
 */
@property(nonatomic,weak)EFBaseViewController* controller;
/*!
 *  @brief  适配器Dictionary
 */
@property(nonatomic,strong)NSMutableDictionary* pAdaptorDict;

@property(nonatomic,readonly) BOOL isHidden;

@property(nonatomic,strong)EFBaseViewModel* viewModel;


@end
