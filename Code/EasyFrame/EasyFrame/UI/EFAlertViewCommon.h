/*!
 @header EFAlertViewCommon.h
 @abstract 定义一个弹出对话框组件，使用Delegate返回
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */
#import <Foundation/Foundation.h>

#define EFALERTCOMMON_TYPE_ONE_BUTTON  0
#define EFALERTCOMMON_TYPE_TWO_BUTTON  1


/*!
 *  @protocol 对话框返回协议
 *  @brief
 */
@protocol EFAlertViewCommonDelegate <NSObject>
@optional
/*!
 *  @brief  双按钮，“是”按钮点击返回后的代理
 *
 *  @param sender 点击对象
 */
- (void)efAlertViewDelegateYesButtonClick:(id)sender;
/*!
 *  @brief  双按钮，“否”按钮点击返回后的代理
 *
 *  @param sender 点击对象
 */
- (void)efAlertViewDelegateNoButtonClick:(id)sender;
/*!
 *  @brief  单按钮，“否”按钮点击返回后的代理
 *
 *  @param sender 点击对象
 */
- (void)efAlertViewDelegateConfirmButtonClick:(id)sender;
/*!
 *  @brief  双按钮有载荷，是按钮点击返回后的代理
 *
 *  @param sender 点击对象
 */
- (void)efAlertViewDelegateYesButtonClick:(id)sender andPayload:(id)payload;

/*!
 *  @brief  双按钮,dismiss后的代理
 *
 *  @param alertView UIAlertView对象
 */
- (void)efAlertViewDelegateDidDismissYesButtonClick:(UIAlertView *)alertView;
@end

/*!
 *  @class  对话框类
 *  @brief 定义一个对话框类，简化对话框操作
 */
@interface EFAlertViewCommon : NSObject
{
    NSInteger _alertType;
}
/*!
 *  @brief  代理对象
 */
@property (nonatomic, weak) id<EFAlertViewCommonDelegate> delegate;
/*!
 *  @brief  UIAlertView实例
 */
@property (nonatomic, strong) UIAlertView* alertView;
/*!
 *  @brief  有效载荷
 */
@property (nonatomic, strong) id payload;
/*!
 *  @brief 开启对话框
 *
 *  @param type      类型，EFALERTCOMMON_TYPE_ONE_BUTTON，EFALERTCOMMON_TYPE_TWO_BUTTON
 *  @param message   消息
 *  @param title     标题
 *  @param yesText_  是按钮文字，如果两个按钮
 *  @param noText_   否按钮文字，如果两个按钮
 *  @param delegate_ 代理
 *  @param tag_      tag,用于表示按钮
 */
- (void)showAlertType:(NSInteger)type andText:(NSString*)message andTitle:(NSString*)title andYesButton:(NSString*)yesText_ andNoButton:(NSString*)noText_ andDelegate:(id)delegate_ andTag:(NSInteger)tag_;
/*!
 *  @brief  关闭对话框
 */
+ (void)closeCurrentAlertView;
/*!
 *  @brief  判断对话框是否显示
 *
 *  @return 是否显示
 */
+ (BOOL)isShowAlertView;

@end
/*!
 *  @class 对话框类回调类
 *  @brief 定义对话框类回调类
 */
@interface EFAlertViewCommonCallback : NSObject
/*!
 *  @brief  获取单例
 *
 *  @return 返回单例
 */
+(id)shareEFAlertViewCallback;
/*!
 *  @brief  添加对话框
 *
 *  @param alertView 对话框对象
 *  @param type      类型
 *  @param delegate  代理
 *  @param payload   载荷
 */
-(void)addAlertView:(UIAlertView*)alertView type:(NSInteger)type delegate:(id<EFAlertViewCommonDelegate>)delegate payload:(id)payload;
/*!
 *  @brief  字典
 */
@property(nonatomic,strong)NSMutableDictionary* alertDict;
@end
