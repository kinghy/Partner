//
//  STOProductSellMarketBll.m
//  Partner
//
//  Created by  rjt on 15/11/25.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductSellMarketBll.h"
#import "STOProductMarketSection.h"
#import "OrdersSellEntity.h"
#import "ContractAlert.h"
#import "CustomIOSAlertView.h"
#import "STOProductSellOrderViewController.h"
#import "STOProductOrderDetailViewController.h"

@implementation STOProductSellMarketBll
-(void)loadBll{
    [super loadBll];
    self.controller.navigationItem.rightBarButtonItem = nil;
}
-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isMemberOfClass:[STOProductMarketSection class]]) {
        STOProductMarketSection *s = (STOProductMarketSection *)section;
        self.mySection = s;
        s.confirmView.hidden = YES;
        s.profitView.hidden = NO;
        s.sellView.hidden = NO;
        [s.sellBtn addTarget:self action:@selector(sellClicked) forControlEvents:UIControlEventTouchUpInside];
        [s.detailBtn addTarget:self action:@selector(detailClicked) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)sellClicked{
    STOProductSellOrderViewController* ctrl = [[STOProductSellOrderViewController alloc] init];
    [self.controller.navigationController pushViewController:ctrl animated:YES];
}

-(void)detailClicked{
    STOProductOrderDetailViewController* ctrl = [[STOProductOrderDetailViewController alloc] init];
    [self.controller.navigationController pushViewController:ctrl animated:YES];
}

@end
