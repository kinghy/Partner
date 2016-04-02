//
//  EFCommonFunction.m
//  EasyFrame
//
//  Created by  rjt on 15/6/16.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#import "EFCommonFunction.h"
#import "EFAlertViewCommon.h"
#import "OpenUDID.h"
//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "EFNotifyHUD.h"

@implementation EFCommonFunction
// 得到设备唯一标识
+ (NSString*)getUniqueDeviceIdentifier
{
    return [OpenUDID value];
}

// 获得设备MAC标识
+ (NSString*)macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

#pragma mark - 弹出alert对话框
// 打开一个警告对话框

+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTitle:(NSString*)title andButton:(NSString*)buttonTitle andTag:(NSInteger)tag andDelegate:(id)delegate
{
    if (!message || ![message length])
        return;
    
    EFAlertViewCommon* alertViewCommon = [[EFAlertViewCommon alloc] init];
    [alertViewCommon showAlertType:EFALERTCOMMON_TYPE_ONE_BUTTON andText:message andTitle:title andYesButton:buttonTitle andNoButton:nil andDelegate:delegate andTag:tag];
}

+ (void)messageBoxWithMessage:(NSString*)message
{
    [EFCommonFunction messageBoxOneButtonWithMessage:message andTitle:nil andButton:nil andTag:0 andDelegate:nil];
}

+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [EFCommonFunction messageBoxOneButtonWithMessage:message andTitle:nil andButton:nil andTag:tag andDelegate:delegate];
}

+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTitle:(NSString*)title andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [EFCommonFunction messageBoxOneButtonWithMessage:message andTitle:title andButton:nil andTag:tag andDelegate:delegate];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andLeftButton:(NSString*)leftButtonTitle andRightButton:(NSString*)rightButtonTitle andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [EFCommonFunction messageBoxTwoButtonWithMessage:message andTitle:title andLeftButton:leftButtonTitle andRightButton:rightButtonTitle andTag:tag andDelegate:delegate andPayload:nil];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [EFCommonFunction messageBoxTwoButtonWithMessage:message andTitle:nil andLeftButton:nil andRightButton:nil andTag:tag andDelegate:delegate];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [EFCommonFunction messageBoxTwoButtonWithMessage:message andTitle:title andLeftButton:nil andRightButton:nil andTag:tag andDelegate:delegate];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate andPayload:(id)payload{
    [EFCommonFunction messageBoxTwoButtonWithMessage:message andTitle:nil andLeftButton:nil andRightButton:nil andTag:tag andDelegate:delegate andPayload:payload];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andLeftButton:(NSString*)leftButtonTitle andRightButton:(NSString*)rightButtonTitle andTag:(NSInteger)tag andDelegate:(id)delegate andPayload:(id)payload{
    if (!message || ![message length])
        return;
    
    if(!leftButtonTitle)
        leftButtonTitle=@"取消";
    
    if(!rightButtonTitle)
        rightButtonTitle=@"确定";
    
    EFAlertViewCommon* alertViewCommon = [[EFAlertViewCommon alloc] init];
    alertViewCommon.payload = payload;
    [alertViewCommon showAlertType:EFALERTCOMMON_TYPE_TWO_BUTTON andText:message andTitle:title andYesButton:rightButtonTitle andNoButton:leftButtonTitle andDelegate:delegate andTag:tag];
}

+ (BOOL)isShowMessageBox
{
    return [EFAlertViewCommon isShowAlertView];
}

// 设置圆角
+ (void)setView:(UIView*)view cornerRadius:(CGFloat)radius color:(CGColorRef)color borderWidth:(CGFloat)width
{
    CALayer* layer = view.layer;
    
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    
    layer.borderColor = color;
    layer.borderWidth = width;
}


//在视图中间显示浮层
+(void)showNotifyHUDAtViewCenter:(UIView*)view withErrorMessage:(NSString *)errorMessage withTextField:(UITextField*)textField{
    [self showNotifyHUDAtViewCenter:view withErrorMessage:errorMessage withTextField:textField withBackColor:nil];
}

+(void)showNotifyHUDAtViewCenter:(UIView*)view withErrorMessage:(NSString *)errorMessage withTextField:(UITextField*)textField  withBackColor:(UIColor*)backgroundColor{
    for (UIView *notifyView in view.subviews) {
        if ([notifyView isMemberOfClass:[EFNotifyHUD class]]) {
            EFNotifyHUD *notify = (EFNotifyHUD*)notifyView;
            //判断的hud是否已消失
            if(notify.currentOpacity > 0  ){
                return;
            }else{
                [notifyView removeFromSuperview];
                
            }
        }
    }
    
    EFNotifyHUD *notify = [EFNotifyHUD notifyHUDWithImage:nil text:errorMessage];
    if (backgroundColor) {
        notify.backgroundColor = backgroundColor;
    }
    if (errorMessage.length > 16) {
        if (textField) {
            
            if (textField.keyboardType == UIKeyboardTypeDefault) {
                notify.frame = CGRectMake(40,view.frame.size.height-216-95, 0, 0);
            }
            else{
                notify.frame = CGRectMake(40,view.frame.size.height-216-60, 0, 0);
            }
        }
        else{
            if (textField.keyboardType == UIKeyboardTypeDefault) {
                notify.frame = CGRectMake(40,view.frame.size.height-216-75, 0, 0);
            }
            else{
                notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
            }
            
        }
        
    }
    [view addSubview:notify];
    [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
        [notify removeFromSuperview];
    }];
}

//在视图中部显示浮层
+(void)showNotifyHUDAtViewCenter:(UIView*)view  withErrorMessage:(NSString *)errorMessage{
    [self showNotifyHUDAtViewCenter:view withErrorMessage:errorMessage withBackColor:nil];
}

+(void)showNotifyHUDAtViewCenter:(UIView*)view  withErrorMessage:(NSString *)errorMessage  withBackColor:(UIColor*)backgroundColor{
    
    if (!errorMessage || [errorMessage isEqualToString:@""]) return;
    
    for (UIView *notifyView in view.subviews) {
        if ([notifyView isMemberOfClass:[EFNotifyHUD class]]) {
            EFNotifyHUD *notify = (EFNotifyHUD*)notifyView;
            //判断的hud是否已消失
            if(notify.currentOpacity > 0  ){
                return;
            }else{
                [notifyView removeFromSuperview];
                
            }
        }
    }
    
    EFNotifyHUD *notify = [EFNotifyHUD notifyHUDWithImage:nil text:errorMessage];
    notify.frame = CGRectMake(40,view.frame.size.height - 40, 0, 0);
    if (backgroundColor) {
        notify.backgroundColor = backgroundColor;
    }
    if (errorMessage.length > 16) {
        notify.frame = CGRectMake((kCurrentDeviceWidth - kBDKNotifyHUDDefaultWidth)/2,(kCurrentDeciceHeight)/2, 0, 0);
    }
    else{
        notify.frame = CGRectMake((kCurrentDeviceWidth - kBDKNotifyHUDDefaultWidth)/2,(kCurrentDeciceHeight)/2, 0, 0);
    }
    [view addSubview:notify];
    [notify presentWithDuration:0.5f speed:0.5f inView:view completion:^{
        [notify removeFromSuperview];
    }];
}

//在视图底部显示浮层

+(void)showNotifyHUDAtViewBottom:(UIView*)view  withErrorMessage:(NSString *)errorMessage{
    [self showNotifyHUDAtViewBottom:view withErrorMessage:errorMessage withBackColor:nil];
}

+(void)showNotifyHUDAtViewBottom:(UIView*)view  withErrorMessage:(NSString *)errorMessage  withBackColor:(UIColor*)backgroundColor{
    
    if (!errorMessage || [errorMessage isEqualToString:@""]) return;
    
    for (UIView *notifyView in view.subviews) {
        if ([notifyView isMemberOfClass:[EFNotifyHUD class]]) {
            EFNotifyHUD *notify = (EFNotifyHUD*)notifyView;
            //判断的hud是否已消失
            if(notify.currentOpacity > 0  ){
                return;
            }else{
                [notifyView removeFromSuperview];
                
            }
        }
    }
    
    EFNotifyHUD *notify = [EFNotifyHUD notifyHUDWithImage:nil text:errorMessage];
    notify.frame = CGRectMake(40,view.frame.size.height - 40, 0, 0);
    if (backgroundColor) {
        notify.backgroundColor = backgroundColor;
    }
    
    if (errorMessage.length > 16) {
        notify.frame = CGRectMake((kCurrentDeviceWidth - kBDKNotifyHUDDefaultWidth)/2,view.frame.size.height-60, 0, 0);
    }
    else{
        notify.frame = CGRectMake((kCurrentDeviceWidth - kBDKNotifyHUDDefaultWidth)/2,view.frame.size.height-40, 0, 0);
    }
    [view addSubview:notify];
    [notify presentWithDuration:1.0f speed:0.5f inView:view completion:^{
        [notify removeFromSuperview];
    }];
}

+(UIImage *)imageWithColor:(UIColor*)color{
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

@end

