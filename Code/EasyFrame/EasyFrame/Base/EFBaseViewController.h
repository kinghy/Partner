//
//  EFBaseViewController.h
//  EasyFrame
//
//  Created by  rjt on 15/6/12.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFBaseViewController;

@protocol EFBaseViewControllerDelegate <NSObject>
@optional
-(void)viewController:(EFBaseViewController*)controller dismissedWithObject:(id)obj;
@end

@class EFBll;
@interface EFBaseViewController : UIViewController <EFBaseViewControllerDelegate>{
    NSHashTable *blls; //存放bll列表用于发送必要通知，保存弱引用
    NSMapTable *switcher;//存放用来切换bll的控制器与其对应关系
    EFBaseViewModel* _viewModel;
}

/*!
 *  @brief 创建ViewController并设置ViewModel的方法
 *
 *  @param viewModel viewModel实例，子类需要实现typeOfModel方法
 *  @param nibName   nibName
 *  @param bundle    bundel
 *
 *  @return 返回创建后的实例
 */
+(instancetype)controllerWithModel:(EFBaseViewModel*)viewModel nibName:(NSString*)nibName bundle:(NSBundle*)bundle;

/*!
 *  @brief 创建ViewController的方法
 *
 *  @param nibName nibName
 *  @param bundle  bundel
 *
 *  @return 返回创建后的实例
 */
+(instancetype)controllerWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle;

/*!
 *  @brief 返回ViewModel的实例，子类实现
 *
 *  @return 返回需要实例类型
 */
-(Class)typeOfModel;

/*!
 *  @brief  初始化Bll，子类实现
 */
-(void)initBll;

/*!
 *  @brief  MVVM模式绑定ViewModel
 */
-(void)bindViewModel;

/*!
 *  @brief  添加bll以便发送相关通知，由Bll调用此方法注册自己
 *
 *  @param bll 需要注册的bll
 */
-(void)registerBll:(EFBll*)bll;

/**
 *  设置导航栏右侧按钮
 *
 *  @param title  按钮标题
 *  @param img    按钮图标
 *  @param action 按钮出发方法
 */
-(void)setRightNavBarWithTitle:(NSString*) title image:(UIImage*)img action:(SEL)action;

/**
 *  绑定切换控制台，用来切换bll
 *
 *  @param sw  开关
 *  @param bll bll实例
 */
-(void)addSwither:(UIControl*)sw forBll:(EFBll*)bll;

/**
 *  当切换bll时触发此方法
 *
 *  @param sw     被选中的按钮
 *  @param bll    被选中的bll
 *  @param oldSw  先前被选中的按钮
 *  @param oldbll 先前被选中的bll
 */
-(void)swither:(UIControl*)sw andBll:(EFBll*)bll fromSwitcher:(UIControl*)oldSw andBll:(EFBll*)oldbll;

/*!
 *  @brief 关闭模态框，并且调用代理viewController:dismissedWithObject:方法
 *
 *  @param flag       flag
 *  @param userObj    传递给代理实现类的数据
 *  @param completion completion
 */
-(void)dismissViewControllerAnimated:(BOOL)flag userObj:(id)userObj completion:(void (^)(void))completion ;

-(void)switchClicked:(id)obj;

@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic) BOOL navBarHidden;

@property (nonatomic,weak) id<EFBaseViewControllerDelegate> delegate;

@property (nonatomic,strong) EFBaseViewModel* viewModel;

@end
