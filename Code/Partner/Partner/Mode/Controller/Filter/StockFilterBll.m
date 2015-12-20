//
//  StockFilterBll.m
//  Partner
//
//  Created by kinghy on 15/10/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "StockFilterBll.h"
#import "ProductEntity.h"
#import "FilterSection.h"

@implementation StockFilterBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adaptor = [super loadEFUIWithTable:tableView andKey:key];
    ProductEntity* entity = [ProductEntity entity];
    entity.title = @"沪深A股";
    entity.investMoney = @"100万元";
    entity.investLimit = @"10交易日";
    entity.bailRate = @"30%";
    entity.earnest = @"50：50";
    entity.logo = @"stockA";
    [adaptor addEntity:entity withSection:[FilterSection class]];
    return adaptor;
}
@end
