//
//  STOProductFreeStyleBll.h
//  Partner
//
//  Created by  rjt on 15/11/12.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBll.h"

@class STOProductFreeStyleSection;
@class STOProductFreeStyleViewModel;
@interface STOProductFreeStyleBll : EFBll<UITableViewDataSource,UITableViewDelegate>{
    BOOL isSearch;
}

-(void)goMarket:(StockEntity*)entity;//买入指定股票

@property (nonatomic,strong) STOProductManager *manager;
@property (nonatomic,strong) STOProductFreeStyleSection *mySection;

@end
