//
//  ProductKChartEntity.h
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//
//k线图

#import "AppEntity.h"

@interface ProductKChartEntity : AppEntity

/**产品代码*/
@property (nonatomic,copy) NSString *stockcode;
/**产品名称*/
@property (nonatomic,copy) NSString *stockname;
/**天数*/
@property (nonatomic,copy) NSString *Count;
/**日数据列表*/
@property (nonatomic,strong) NSMutableArray *records;
@end


@interface ProductKChartRecordsEntity : AppEntity
/**日期*/
@property (nonatomic,copy) NSString *date;
/**收盘价*/
@property (nonatomic,copy) NSString *YClose;
/**最新价*/
@property (nonatomic,copy) NSString *New;
/**最高价*/
@property (nonatomic,copy) NSString *High;
/**最低价*/
@property (nonatomic,copy) NSString *Low;
/**开盘价*/
@property (nonatomic,copy) NSString *Open;
/**成交量*/
@property (nonatomic,copy) NSString *Volume;
/**成交金额*/
@property (nonatomic,copy) NSString *Amount;
/**时间，只有分钟K线*/
@property (nonatomic,copy) NSString *time;

/**60日均价**/
@property (nonatomic,assign) float MA60;
@property (nonatomic,assign) float VOL60;
/**20日均价**/
@property (nonatomic,assign) float MA20;
@property (nonatomic,assign) float VOL20;
/**10日均价**/
@property (nonatomic,assign) float MA10;
@property (nonatomic,assign) float VOL10;
/**5日均价**/
@property (nonatomic,assign) float MA5;
@property (nonatomic,assign) float VOL5;
@end
