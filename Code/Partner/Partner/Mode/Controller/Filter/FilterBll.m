//
//  FilterBll.m
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "FilterBll.h"
#import "FilterSection.h"
#import "ProductEntity.h"
#import "FilterListViewController.h"

@implementation FilterBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"FilterSection"] delegate:self];
    adpator.fillParentEnabled = YES;
    return adpator;
}

-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[FilterSection class]] && [entity isKindOfClass:[ProductEntity class]]) {
        FilterSection* s = (FilterSection*)section;
        ProductEntity* e = (ProductEntity*)entity;
        s.investMoney.text = e.investMoney;
        s.investLimit.text = e.investLimit;
        s.bailRate.text = e.bailRate;
        s.ernest.text = e.earnest;
        [s.investMoneyBtn addTarget:self action:@selector(listClicked:) forControlEvents:UIControlEventTouchUpInside];
        [s.investLimitBtn addTarget:self action:@selector(listClicked:) forControlEvents:UIControlEventTouchUpInside];
        [s.bailRateBtn addTarget:self action:@selector(listClicked:) forControlEvents:UIControlEventTouchUpInside];
        [s.ernestBtn addTarget:self action:@selector(listClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)listClicked:(UIView*)view{
    FilterListViewController* list = [[FilterListViewController alloc] init];
    list.title = @"投资金额";
    [self.controller.navigationController pushViewController:list animated:YES];
}

@end
