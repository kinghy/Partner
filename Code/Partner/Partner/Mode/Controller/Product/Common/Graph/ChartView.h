//
//  ChartView.h
//  chart
//
//  Created by  rjt on 15/5/27.
//  Copyright (c) 2015年 JYZD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductPanKouEntity;

@interface ChartView : UIView

@property(strong,nonatomic)NSString* jingdu;            //精度


/*!
 *  @brief  组装分时图
 *
 *  @param line      折线图
 *  @param histogram 柱状图
 *  @param handicap  盘口
 */
-(void)installChartWithLine:(BOOL)line histogram:(BOOL)histogram handicap:(BOOL)handicap;

/*!
 *  @brief  组装分时图
 *
 *  @param line      折线图
 *  @param histogram 柱状图
 *  @param handicap  盘口
 *  @param resize    是否调整大小
 */
-(void)installChartWithLine:(BOOL)line histogram:(BOOL)histogram handicap:(BOOL)handicap resize:(BOOL)resize;

/*!
*  @brief  绘制分时图价格部分
*
*  @param prices        包含从开盘始截止到当前为止的每分钟均价的数组
*  @param close         昨收价
*  @param high          今日最高价
*  @param low           今日最低价
*  @param open          开拍价
*  @param time          当前市场时间
*  @param needAnimation 是否需要从左至右逐渐展开的动画效果
*  @param min           盘中时长（开盘至收盘有多少分钟）
*  @param sptime        下标分割时间点
*  @param spdiffer      每个分割点间所包含几分钟
*/
-(void)drawChartWithPrices:(NSArray*)prices
                    yClose:(NSString*)close
                 highPrice:(NSString*)high
                  lowPrice:(NSString*)low
                 openPrice:(NSString*)open
                      time:(NSString*)time
                 animation:(BOOL)needAnimation
                allMinutes:(int)min
                spliteTime:(NSArray*) sptime
               splitDiffer:(NSArray*) spdiffer;


/*!
 *  @brief  绘制自由式分时图价格部分，不以昨收价为标杆
 *
 *  @param prices        包含从开盘始截止到当前为止的每分钟均价的数组
 *  @param close         昨收价
 *  @param high          今日最高价
 *  @param low           今日最低价
 *  @param open          开拍价
 *  @param time          当前市场时间
 *  @param needAnimation 是否需要从左至右逐渐展开的动画效果
 *  @param min           盘中时长（开盘至收盘有多少分钟）
 *  @param sptime        下标分割时间点
 *  @param spdiffer      每个分割点间所包含几分钟
 */
-(void)drawFreeStyleChartWithPrices:(NSArray*)prices
                             yClose:(NSString*)close
                          highPrice:(NSString*)high
                           lowPrice:(NSString*)low
                          openPrice:(NSString*)open
                               time:(NSString*)time
                          animation:(BOOL)needAnimation
                         allMinutes:(int)min
                         spliteTime:(NSArray*) sptime
                        splitDiffer:(NSArray*) spdiffer;


/*!
 *  @brief 绘制分时图成交量部分
 *
 *  @param vols          包含从开盘始截止到当前为止的每分钟成交量的数组
 *  @param needAnimation 是否需要从左至右逐渐展开的动画效果
 *  @param isStock       是否股票类产品
 *  @param min           盘中时长（开盘至收盘有多少分钟）
 *  @param sptime        下标分割时间点
 *  @param spdiffer      每个分割点间所包含几分钟
 */
-(void)drawChartWithVols:(NSArray*)vols
               animation:(BOOL)needAnimation
                   stock:(BOOL)isStock
              allMinutes:(int)min
              spliteTime:(NSArray*) sptime
             splitDiffer:(NSArray*) spdiffer;

/*!
 *  @brief  绘制5档买卖信息
 *
 *  @param handicap 5档买卖信息
 */
-(void)drawChartWithHandicap:(ProductPanKouEntity*)handicap;

/*!
 *  @brief  开启最新价脉动动画
 */
-(void)startPulse;
/*!
 *  @brief  关闭最新价脉动动画
 */
-(void)endPulse;

@end
