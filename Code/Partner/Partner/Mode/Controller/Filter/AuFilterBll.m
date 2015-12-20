//
//  AuFilterBll.m
//  Partner
//
//  Created by kinghy on 15/10/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AuFilterBll.h"
#import "ProductEntity.h"
#import "FilterSection.h"

@implementation AuFilterBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adaptor = [super loadEFUIWithTable:tableView andKey:key];
    ProductEntity* entity = [ProductEntity entity];
    entity.title = @"沪金";
    entity.investMoney = @"10万元";
    entity.investLimit = @"5交易日";
    entity.bailRate = @"10%";
    entity.earnest = @"40：60";
    entity.logo = @"stockA";
    [adaptor addEntity:entity withSection:[FilterSection class]];
    return adaptor;
}
@end
