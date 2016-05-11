//
//  AppMacro.h
//  EasyFrame
//
//  Created by  rjt on 15/6/17.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#ifndef EasyFrame_AppMacro_h
#define EasyFrame_AppMacro_h

// 底部tabbar的高度设置为49
#define KTabBarHeight 49.0

//忽略的版本号
#define kIgnorVersion @"ignoreVersion"

/** AppDelegate的宏 */
#define  kShareAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//默认导航条颜色
// 自定义RGB色值
#define kColorLogin Color_Bg_RGB(177,206,249)

#define kColorSearchBorder Color_Bg_RGB(215,215,215)

#define kColorSwitchUnselected Color_Bg_RGB(74,146,244)

#define Color_DS_Gray Color_Bg_RGB(195.f, 210.f, 255.f)//平灰
#define Color_Up_Red Color_Bg_RGB(255.0f,118.0f, 151.0f)//涨红2
#define Color_Down_Green Color_Bg_RGB(74.0f, 217.0f, 159.0f)//跌绿2
#define Color_Up_Red_Change Color_Bg_RGB(255.0f,173.0f, 186.0f)//涨红涨幅变动
#define Color_Down_Green_Change Color_Bg_RGB(119.0f, 219.0f, 179.0f)//跌绿跌幅变动
#define Color_Bg_Blue Color_Bg_RGB(157.0f, 208.0f, 249.0f)//成交量蓝色
#define Color_Bg_Black1 Color_Bg_RGB(34.0f, 34.0f, 34.0f)//盘口文字
#define Color_Bg_Black2 Color_Bg_RGB(66.0f, 66.0f, 66.0f)//盘口数量
#define Color_Bg_Gray Color_Bg_RGB(195.0f, 195.0f, 195.0f)//成交量
#define Color_Bg_GrayFont Color_Bg_RGB(135.0f, 135.0f, 135.0f)//成交量数字0
#define Color_Bg_Text_Chosed_Blue Color_Bg_RGB(48.0f, 138.0f, 244.0f)
#define Color_Bg_Text_UnChosed_Blue Color_Bg_RGB(117.0f, 117.0f, 117.0f)

//全局大按钮蓝色Color_Bg_RGB(89, 161, 246)
#define Color_Confirm_Blue Color_Bg_RGB(89.0f, 161.0f,  246.0f)
#define Color_Confirm_Blue_Highlighy Color_Bg_RGB(80.0f, 148.0f,  228.0f)
#define Color_Confirm_Gray Color_Bg_RGB(171.0f, 171.0f, 171.0f)//三级文字

#define Color_Btn_Disabled Color_Bg_RGB(197.0f, 197.0f, 197.0f)//按钮不可点标准色

#define Color_Bg_757575 Color_Bg_RGB(117.0f, 117.0f, 117.0f)//二级文字

#define Color_Time_Line Color_Bg_RGB(100.0f, 132.0f, 180.0f)//分时折线色
#define Color_Time_Fill Color_Bg_RGBA(143.0f, 189.0f, 255.0f, 0.4f)//分时填充色

#define kColorNavBarSwitchButton Color_Bg_RGB(64,138,205)//导航条选择按钮

#define kColorLogoBorder Color_Bg_RGB(84,121,138)//logo边框色

//筛选按钮颜色
#define kColorFilterChosedBtnBorder Color_Bg_RGB(92.0f, 124.0f, 215.0f)
#define kColorFilterChoserBtnBG Color_Bg_RGB(136.0f , 162.0f, 237.0f)


#define kStockLastChosed @"kStockLastChosed"

#define kGraphTime @"kGraphTime" //图
#define kFreeStyleTime @"kFreeStyleTime" //自选股

#define kFreeStyleKey @"kFreeStyleKey"   //股票行情图
#define kFreeStyleValue 3

#define kHqChartKey @"kHqChartKey"   //股票行情图
#define kHqChartValue 20

#define kHqVolChartKey @"kHqVolChartKey"  //股票行情图
#define kHqVolChartVal 20

#define kHqKChartKey @"kHqKchartKey"  //股票K线图
#define kHqKChartVal 30

#define kPankouKey @"kPankouKey"  //股票K线图
#define kPankouVal 3

/* 开盘闭盘时间   */
#define kSTFOpenTime @"09:00"
#define kSTOOpenTime @"09:00"
#define kIFOpenTime @"09:15"

#define kAUNightOpenTime @"21:00"
#define kAGNightOpenTime @"21:00"
#define kAUNightCloseTime @"02:30"
#define kAGNightCloseTime @"02:30"

#define kAUDayOpenTime @"09:00"
#define kAGDayOpenTime @"09:00"
#define kAUDayCloseTime @"15:00"
#define kAGDayCloseTime @"15:00"

#define kSTFCloseTime @"15:00"
#define kSTOCloseTime @"15:00"
#define kIFCloseTime @"15:15"

#define kHQViewNeedCodeString @"kHqCodeString" //基金行情界面需要的code

/** 产品名称 **/
#define kSTOName @"stock"
#define kIFName @"spif"
#define kAUName @"au"
#define kAGName @"ag"
#define kSTFName @"stf"

/** 定时刷新key **/

#define kHqRefresh @"kHqRefresh" //期指行情刷新key
#define kOrderHqRefresh @"kOrderHqRefresh" //期指行情刷新key
#define kSellOrderHqRefresh @"kSellOrderHqRefresh" //期指行情刷新key

#define kHqOnceTaskVal 3 //行情的值，秒
#define kOrderHqOnceTaskVal 3 //行情的值，秒
#define kSellOrderHqOnceTaskVal 3 //行情的值，秒

#define kStoCodeSH @"sh.999999"
#define kStoNameSH @"上证指数"

#define kStoCodeSZ @"399001"
#define kStoNameSZ @"深圳成指"

#define kStoCode300 @"399300"
#define kStoName300 @"沪深300"

#define HQ_URL_DAY @"http://hqd.jyzd.com"
#define HQ_URL_NIGHT @"http://hqn.jyzd.com"
#define SERVER_URL @"http://115.159.94.39:10010"

//忽略所有错误代码
#define IGNORE_ERROR_CODE                   -999999
#endif


