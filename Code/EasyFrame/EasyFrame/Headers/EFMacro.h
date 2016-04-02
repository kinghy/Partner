/*!
 @header EFMacro.h
 @abstract 定义常用宏
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */

#ifndef EasyFrame_EFMacro_h
#define EasyFrame_EFMacro_h

//dealloc时的输出方法宏
#define show_dealloc_info(obj) DDLogInfo(@"%@ has dealloced",[obj class]);

// 自定义RGB色值
#define Color_Bg_RGB(x, y, z) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:1.0f]
#define Color_Bg_RGBA(x, y, z,a) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:a]
//导航条颜色
#define kColorNavBar Color_Bg_RGB(255, 255, 255)
#define kColorNavTitle Color_Bg_RGB(34 , 34, 34)
//tab条颜色
#define kColorTabBar Color_Bg_RGB(60, 84, 153)

#define kSouceGroupHeight 64.f
#define kCellHeight 48.f

#define kLineColor Color_Bg_RGB(220,220,220)
#define kFilterChosedColor Color_Bg_RGB(74,146,244)

#define kBtnColor Color_Bg_RGB(255,177,42)
#define kBtnColorSelected Color_Bg_RGB(254,161,0)

#define FIVE_LINE_COLOR [UIColor colorWithRed:100.f/255.f green:100.f/255.f blue:100.f/255.f alpha:1]
#define TEN_LINE_COLOR [UIColor colorWithRed:255.f/255.f green:199.f/255.f blue:59.f/255.f alpha:1]
#define TWENTY_LINE_COLOR [UIColor colorWithRed:50.f/255.f green:171.f/255.f blue:246.f/255.f alpha:1]
#define SIXTY_LINE_COLOR  [UIColor colorWithRed:194.f/255.f green:90.f/255.f blue:255.f/255.f alpha:1]


//手机规格

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kCurrentDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kCurrentDeciceHeight [UIScreen mainScreen].bounds.size.height

#define IOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define kGetVersion  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

//弱引用self
#define DEFINED_WEAK_SELF __weak typeof(self) _self = self;


//ReactiveCocoa宏
#define RACErrorDomain @"RACErrorDomain"
#define RACErrorCode 99999999
#define RACErrorMsgKey @"msg"

#define RACErrorFromMsg(msg) [NSError errorWithDomain:RACErrorDomain code:RACErrorCode userInfo:@{RACErrorMsgKey:msg}]
#define RACMsgFormError(error) error.userInfo[RACErrorMsgKey]

#endif
