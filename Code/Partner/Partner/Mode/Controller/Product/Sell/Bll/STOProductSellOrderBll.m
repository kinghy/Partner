//
//  STOProductSellOrderBll.m
//  Partner
//
//  Created by  rjt on 15/11/26.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductSellOrderBll.h"
#import "STOProductSellOrderSection.h"
#import "ProductPanKouEntity.h"
#import "CustomIOSAlertView.h"
#import "OrdersSellEntity.h"
#import "ContractAlert.h"
#import "STOProductViewController.h"

@implementation STOProductSellOrderBll

-(void)loadBll{
    self.manager = [STOProductManager shareSTOProductManager];
    [super loadBll];
}

-(void)controllerWillAppear{
    [self initTimer];
}

-(void)controllerDidDisappear{
    [[WHTimerManager shareTimerManager] removeTarget:self notifyName:kSellOrderHqRefresh];
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor * adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"STOProductSellOrderSection"] delegate:self];
    [adpator addEntity:[EFEntity entity] withSection:[STOProductSellOrderSection class]];
    adpator.fillParentEnabled = YES;
//    adpator.scrollEnabled = YES;
    return adpator;
}
-(void)initTimer{
    if (![[WHTimerManager shareTimerManager]hasNotifyName:kSellOrderHqRefresh]) {
        [[WHTimerManager shareTimerManager]addTarget:self selector:@selector(refreshHqData) notifyName:kSellOrderHqRefresh];
    }
}

-(void)refreshHqData{
    if ([[WHOnceTask shareOnceTask]expired:kSellOrderHqRefresh validTime:kSellOrderHqOnceTaskVal]) {
        [self getHqData];
    }
}

-(void)getHqData{
    if (self.manager.chosedStock) {
        DEFINED_WEAK_SELF
        [self.manager refreshPankou:^(EFEntity *entity, NSError *error) {
            _self.pankouEntity = (ProductPanKouEntity*) entity;
            [_self.pAdaptorDict[kBllUniqueTable] notifyChanged];
        }];
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if( [section isKindOfClass:[STOProductSellOrderSection class]]){
        STOProductSellOrderSection *s = (STOProductSellOrderSection*)section;
        self.mySection = s;
        [s.confirmBtn addTarget:self action:@selector(sellClicked) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if( [section isKindOfClass:[STOProductSellOrderSection class]]){
        STOProductSellOrderSection *s = (STOProductSellOrderSection*)section;
        if (self.manager.chosedStock) {
            s.nameLabel.text = self.manager.chosedStock.stockName;
            s.codeLabel.text = self.manager.chosedStock.stockCode;
        }
        if (self.pankouEntity) {
            s.priceLabel.text = self.pankouEntity.New;
            s.priceLabel.textColor = [AppUtil colorWithOpen:[self.pankouEntity.YClose floatValue] andNew:[self.pankouEntity.New floatValue]];
        }
        
        if (self.manager.chosedOrder) {
            s.contractNoLabel.text = self.manager.chosedOrder.contractNo;
            s.amountLabel.text = self.manager.chosedOrder.amount;
            float stockcount = [self.manager.chosedOrder.amount floatValue]/[self.manager.chosedOrder.price floatValue];
            s.countLabel.text = [NSString stringWithFormat:@"%.0f股",stockcount];
            if (self.pankouEntity.New) {
                float nowValue = stockcount*[self.pankouEntity.New floatValue];
                float profit = nowValue - [self.manager.chosedOrder.amount floatValue];
                if (profit>0) {
                    s.profitLabel.text = [NSString stringWithFormat:@"+%.2f",profit];
                    s.profitLabel.textColor = Color_Up_Red;
                }else if(profit<0){
                    s.profitLabel.text = [NSString stringWithFormat:@"%.2f",profit];
                    s.profitLabel.textColor = Color_Down_Green;
                }else{
                    s.profitLabel.text = [NSString stringWithFormat:@"%.2f",profit];
                    s.profitLabel.textColor = Color_DS_Gray;
                }
            }
            
        }
        
    }
}


-(void)sellClicked{
    ProductOrdersRecordsEntity *order = [STOProductManager shareSTOProductManager].chosedOrder;
    StockEntity * stock= [STOProductManager shareSTOProductManager].chosedStock;
    [[STOProductManager shareSTOProductManager] sellWithCode:stock.stockCode andAmount:order.amount andPrice:self.pankouEntity.New andContractId:order.contractId andReturnBlock:^(EFEntity *entity, NSError *error) {
        if(error==nil && [entity isKindOfClass:[OrdersSellEntity class]]){
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ContractAlert" owner:self options:nil];

            ContractAlert *view = (ContractAlert*)nibs[0];
            view.img.image = [UIImage imageNamed:@"contract_successed"];
            view.label.text = @"恭喜，卖出成功！";

            view.label.numberOfLines = 0;
            //        alert.dialogView = view;
            // Add some custom content to the alert view
            [alertView setContainerView:view];
            // Modify the parameters
            // You may use a Block, rather than a delegate.
            [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                [alertView close];
                [AppUtil controller:self.controller go2Controller:[STOProductViewController class] animated:YES];
            }];

            [alertView setUseMotionEffects:false];

            alertView.buttonTitles = @[@"确定"];
            [alertView show];
        }
    }];
}

@end
