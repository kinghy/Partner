//
//  CPBStockEntity.h
//  CaoPanBao
//
//  Created by 余龙 on 14/10/30.
//  Copyright (c) 2014年 weihui. All rights reserved.
//2、根据关键字简称等搜索股票简单信息

#import "AppEntity.h"

@interface StockEntity : AppEntity

/**stockCode	String	Y	股票代码*/
@property (nonatomic,copy) NSString *stockCode;
/**stockName	String	Y	股票名称*/
@property (nonatomic,copy) NSString *stockName;
/**stockAb	String	Y	股票缩写*/
@property (nonatomic,copy) NSString *stockAb;

@property (nonatomic,copy) NSString *codeShsz;

@end
