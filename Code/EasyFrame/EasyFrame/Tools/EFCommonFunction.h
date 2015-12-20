/*!
 @header EFCommonFunction.h
 @abstract 工具方法类
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */
#import <Foundation/Foundation.h>

@interface EFCommonFunction : NSObject

/*!
 *  @brief  获得OpenUDID
 *
 *  @return 返回OpenUDID
 */
+ (NSString*)getUniqueDeviceIdentifier;

/*!
 *  @brief  获得获得Mac地址
 *
 *  @return 返回Mac地址
 */
+ (NSString*)macaddress;

/*!
 *  @brief  显示一个单按钮对话框
 *
 *  @param message     显示信息
 *  @param title       标题
 *  @param buttonTitle 按钮标题
 *  @param tag         tag标示
 *  @param delegate    代理
 */
+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTitle:(NSString*)title andButton:(NSString*)buttonTitle andTag:(NSInteger)tag andDelegate:(id)delegate;
/*!
 *  @brief  显示一个对话框
 *
 *  @param message     显示信息
 */
+ (void)messageBoxWithMessage:(NSString*)message;
/*!
 *  @brief  显示一个单按钮对话框
 *
 *  @param message     显示信息
 *  @param tag         tag标示
 *  @param delegate    代理
 */
+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate;
/*!
 *  @brief  显示一个单按钮对话框
 *
 *  @param message     显示信息
 *  @param title       标题
 *  @param tag         tag标示
 *  @param delegate    代理
 */
+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTitle:(NSString*)title andTag:(NSInteger)tag andDelegate:(id)delegate;
/*!
 *  @brief  显示两个按钮对话框
 *
 *  @param message     显示信息
 *  @param title       标题
 *  @param leftButtonTitle 左侧按钮标题
 *  @param rightButtonTitle 右侧按钮标题
 *  @param tag         tag标示
 *  @param delegate    代理
 */
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andLeftButton:(NSString*)leftButtonTitle andRightButton:(NSString*)rightButtonTitle andTag:(NSInteger)tag andDelegate:(id)delegate;
/*!
 *  @brief  显示两个按钮对话框
 *
 *  @param message     显示信息
 *  @param tag         tag标示
 *  @param delegate    代理
 */
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate;
/*!
 *  @brief  显示两个按钮对话框
 *
 *  @param message     显示信息
 *  @param title       标题
 *  @param tag         tag标示
 *  @param delegate    代理
 */
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andTag:(NSInteger)tag andDelegate:(id)delegate;
/*!
 *  @brief  显示两个按钮对话框
 *
 *  @param message     显示信息
 *  @param tag         tag标示
 *  @param delegate    代理
 *  @param payload     负载
 */
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate andPayload:(id)payload;

/*!
 *  @brief  显示两个按钮对话框
 *
 *  @param message     显示信息
 *  @param title       标题
 *  @param leftButtonTitle 左侧按钮标题
 *  @param rightButtonTitle 右侧按钮标题
 *  @param tag         tag标示
 *  @param delegate    代理
 *  @param payload     负载
 */
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andLeftButton:(NSString*)leftButtonTitle andRightButton:(NSString*)rightButtonTitle andTag:(NSInteger)tag andDelegate:(id)delegate andPayload:(id)payload;

/*!
 *  @brief  对话框是否显示
 *
 *  @return 是否显示
 */
+ (BOOL)isShowMessageBox;

/*!
 *  @brief  设置圆角
 *
 *  @param view   需要设置的UIVIEW
 *  @param radius 弧度（长或宽的一半）
 *  @param color  颜色
 *  @param width  描边宽度
 */
+ (void)setView:(UIView*)view cornerRadius:(CGFloat)radius color:(CGColorRef)color borderWidth:(CGFloat)width;

/** 在视图中间显示浮层 */
+(void)showNotifyHUDAtViewCenter:(UIView*)view withErrorMessage:(NSString *)errorMessage withTextFiled:(UITextField*)textField;
+(void)showNotifyHUDAtViewCenter:(UIView*)view withErrorMessage:(NSString *)errorMessage withTextFiled:(UITextField*)textField withBackColor:(UIColor*)backgroundColor;
/** 在视图中间显示浮层 */
+(void)showNotifyHUDAtViewCenter:(UIView*)view  withErrorMessage:(NSString *)errorMessage;
+(void)showNotifyHUDAtViewCenter:(UIView*)view  withErrorMessage:(NSString *)errorMessage withBackColor:(UIColor*)backgroundColor;

/** 在视图底部显示浮层 */
+(void)showNotifyHUDAtViewBottom:(UIView*)view  withErrorMessage:(NSString *)errorMessage;
+(void)showNotifyHUDAtViewBottom:(UIView*)view  withErrorMessage:(NSString *)errorMessage withBackColor:(UIColor*)backgroundColor;

@end
