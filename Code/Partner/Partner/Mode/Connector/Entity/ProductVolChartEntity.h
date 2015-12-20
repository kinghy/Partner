//
//  ProductVolChartEntity.h
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//
//分时交易量图

#import "AppEntity.h"

@interface ProductVolChartEntity : AppEntity

/**是否是夜场*/
@property (nonatomic,copy) NSString *night;
/**产品代码*/
@property (nonatomic,copy) NSString *stockcode;
/**产品名称*/
@property (nonatomic,copy) NSString *stockname;
/**昨日收盘价*/
@property (nonatomic,copy) NSString *Yclose;
/**开盘价*/
@property (nonatomic,copy) NSString *Open;
/**最高价*/
@property (nonatomic,copy) NSString *High;
/**最低价*/
@property (nonatomic,copy) NSString *Low;
/**最新价*/
@property (nonatomic,copy) NSString *New;
/**分钟数*/
@property (nonatomic,copy) NSString *Count;
/**分钟交易量列表*/
@property (nonatomic,strong)NSArray *records;
/**市场时间*/
@property (nonatomic,copy) NSString *markettime;
@end
