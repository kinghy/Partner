//
//  STOProductSellBll.m
//  Partner
//
//  Created by  rjt on 15/11/13.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductSellBll.h"
#import "STOProductSellSection.h"
#import "ProductManager.h"
#import "ContractsEntity.h"
#import "ProductOrdersEntity.h"
#import "STODBManager.h"
#import "STOProductSellViewController.h"

@implementation STOProductSellBll

-(void)loadBll{
    [super loadBll];
    [[ProductManager shareProductManager] getUserContracts:^(EFEntity *entity, NSError *error) {
        if (error==nil && [entity isKindOfClass:[ContractsEntity class]]) {
            EFAdaptor * adpator = self.pAdaptorDict[kBllUniqueTable];
            ContractsEntity* e = (ContractsEntity*)entity;
            for(int i=0;i<e.records.count;++i){
                ContractsRecordsEntity* record = e.records[i];
                [adpator.pSources setGroupEntity:record withSection:[STOProductSellSection class] andHeight:0 andGroupName:record.ID];
                [[STOProductManager shareSTOProductManager] sellListWithContractId:record.ID andReturnBlock:^(EFEntity *entity, NSError *error) {
                    if (error==nil && [entity isKindOfClass:[ProductOrdersEntity class]]) {
                        EFAdaptor * adpator = self.pAdaptorDict[kBllUniqueTable];
                        ProductOrdersEntity *e = (ProductOrdersEntity*)entity;
                        for (int i=0;i<e.records.count;++i) {
                            ProductOrdersRecordsEntity* record = e.records[i];
                            [adpator addEntity:e.records[i] withSection:[STOProductSellListSection class] andGroup:record.contractId];
                        }
                        
                        [adpator notifyChanged];
                    }
                }];
                
            }
            [adpator notifyChanged];
        }
        
    }];
}

-(void)EFAdaptor:(EFAdaptor *)adaptor forGroupSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[STOProductSellSection class]]) {
        STOProductSellSection* s = (STOProductSellSection*)section;
        ContractsRecordsEntity* e = (ContractsRecordsEntity*)entity;
        s.name.text = e.contractNo;
        s.amount.text = e.amount;
    }
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor * adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"STOProductSellSection"] delegate:self];
    adpator.scrollEnabled = YES;
    return adpator;
}

-(void)retractClicked:(UIButton*)btn{
    UIResponder *resp = [btn nextResponder];
    while (![resp isKindOfClass:[STOProductSellSection class]]) {
        resp = [resp nextResponder];
    }
    if(resp) {
        STOProductSellSection* s = (STOProductSellSection*)resp;
        
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor selectedSection:(EFSection *)section entity:(EFEntity *)entity{
    if ([section isKindOfClass:[STOProductSellListSection class]]) {
        ProductOrdersRecordsEntity* e = (ProductOrdersRecordsEntity*)entity;
        StockEntity *stock= [[STODBManager shareSTODBManager] accurateSearchWithStockCode:e.stockNo];
        [[STOProductManager shareSTOProductManager] chooseStock:stock];
        [[STOProductManager shareSTOProductManager] chooseOrder:e];
        STOProductSellViewController *ctrl = [[STOProductSellViewController alloc] init];
        [self.controller.navigationController pushViewController:ctrl animated:YES];
    }
    
}

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[STOProductSellSection class]]) {
        STOProductSellSection* s = (STOProductSellSection*)section;
        s.pTabel.delegate = self;
        s.pTabel.dataSource = self;
        [s.retractBtn addTarget:self action:@selector(retractClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[STOProductSellListSection class]]) {
        STOProductSellListSection* s = (STOProductSellListSection*)section;
        ProductOrdersRecordsEntity* e = (ProductOrdersRecordsEntity*)entity;
        
        StockEntity *stock= [[STODBManager shareSTODBManager] accurateSearchWithStockCode:e.stockNo];
        s.stockName.text = stock.stockName;
        s.stockCode.text = stock.stockCode;
        s.cost.text = e.amount;
    }
}


@end
