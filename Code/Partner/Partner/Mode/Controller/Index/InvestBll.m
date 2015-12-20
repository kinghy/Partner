//
//  InvestBll.m
//  Invest
//
//  Created by  rjt on 15/10/22.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "InvestBll.h"
#import "ProductEntity.h"
#import "InvestSection.h"
#import "STOProductMarketViewController.h"
#import "ContractManager.h"
#import "ProductManager.h"
#import "ContractsEntity.h"
#import "MarketEntity.h"
#import "STOProductViewController.h"

@implementation InvestBll
-(void)loadBll{
    [super loadBll];
}

-(void)getMarket{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.controller.view animated:YES];
    [[ProductManager shareProductManager] getMarkets:^(EFEntity *entity, NSError *error) {
        [hud hide:YES];
        if(error==nil && [entity isKindOfClass:[MarketEntity class]]){
            MarketEntity* markets = (MarketEntity*)entity;
            EFAdaptor *adpator = self.pAdaptorDict[kBllUniqueTable];
            [adpator clear];
            for (int i=0; i<markets.records.count;++i ) {
                [adpator addEntity:markets.records[i] withSection:[InvestSection class]];
            }
            [adpator notifyChanged];
        }
    }];
}

-(void)controllerDidAppear{
    [self getMarket];
}

-(void)show{
    [super show];
    [self getMarket];
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"InvestSection"] delegate:self];
    adpator.scrollEnabled = YES;
    return adpator;
}


#pragma marks - EFAdaptorDelegate
-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isMemberOfClass:[InvestSection class]]) {
        MarketRecordsEntity* e = (MarketRecordsEntity*)entity;
        InvestSection* s = (InvestSection*)section;
        s.title.text = e.name;
        s.info.text = e.marketInfo;
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor selectedSection:(EFSection *)section entity:(EFEntity *)entity{
    [ProductManager shareProductManager].selectedMarket = (MarketRecordsEntity*)entity;
    STOProductViewController *controller = [[STOProductViewController alloc] init];
    [self.controller.navigationController pushViewController:controller animated:YES];

}
@end
