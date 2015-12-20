//
//  CreateFilterBll.m
//  Partner
//
//  Created by kinghy on 15/10/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "CreateFilterBll.h"
#import "ProductEntity.h"
#import "FilterSection.h"

@implementation CreateFilterBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adaptor = [super loadEFUIWithTable:tableView andKey:key];
    ProductEntity* entity = [ProductEntity entity];
    entity.title = @"创业板";
    entity.investMoney = @"1万元";
    entity.investLimit = @"1交易日";
    entity.bailRate = @"20%";
    entity.earnest = @"20：80";
    entity.logo = @"stockA";
    [adaptor addEntity:entity withSection:[FilterSection class]];
    return adaptor;
}
@end
