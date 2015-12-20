//
//  ProductPanKouEntity.h
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//
//盘口

#import "AppEntity.h"

@interface ProductPanKouEntity : AppEntity

/**市场时间*/
@property (nonatomic,copy) NSString *markettime;
/**产品代码*/
@property (nonatomic,copy) NSString *stockcode;
/**产品名称*/
@property (nonatomic,copy) NSString *stockname;
/**产品价格*/
@property (nonatomic,copy) NSString *New;
/**开盘价*/
@property (nonatomic,copy) NSString *Open;
/**最高价*/
@property (nonatomic,copy)NSString *High;
/**最低价*/
@property (nonatomic,copy) NSString *Low;
/**昨日收盘价*/
@property (nonatomic,copy)NSString *YClose;
/**涨停价*/
@property (nonatomic,copy)NSString *price_max;
/**跌停价*/
@property (nonatomic,copy) NSString *price_min;

/**买入价1~5*/
@property (nonatomic,copy)NSString *Buy1;
@property (nonatomic,copy) NSString *Buy2;
@property (nonatomic,copy) NSString *Buy3;
@property (nonatomic,copy) NSString *Buy4;
@property (nonatomic,copy)NSString *Buy5;
/**卖出价1~5*/
@property (nonatomic,copy) NSString *Sell1;
@property (nonatomic,copy) NSString *Sell2;
@property (nonatomic,copy) NSString *Sell3;
@property (nonatomic,copy) NSString *Sell4;
@property (nonatomic,copy) NSString *Sell5;
/**买量*/
@property (nonatomic,copy)NSString *BuyVol1;
@property (nonatomic,copy) NSString *BuyVol2;
@property (nonatomic,copy) NSString *BuyVol3;
@property (nonatomic,copy) NSString *BuyVol4;
@property (nonatomic,copy) NSString *BuyVol5;
/**卖量*/
@property (nonatomic,copy) NSString *SellVol1;
@property (nonatomic,copy) NSString *SellVol2;
@property (nonatomic,copy) NSString *SellVol3;
@property (nonatomic,copy) NSString *SellVol4;
@property (nonatomic,copy) NSString *SellVol5;
/**总量*/
@property (nonatomic,copy) NSString *volume;
/**总额*/
@property (nonatomic,copy)NSString *amount;
@end
