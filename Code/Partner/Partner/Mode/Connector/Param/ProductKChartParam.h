//
//  ProductKChartParam.h
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/13.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductKChartEntity.h"

@interface ProductKChartParam : AppParam
/**产品代码*/
@property (nonatomic,copy) NSString *code;
/**K线天数*/
@property (nonatomic,copy) NSString *days;
@end

