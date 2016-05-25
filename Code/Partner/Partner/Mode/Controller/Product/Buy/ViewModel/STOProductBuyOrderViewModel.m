//
//  STOProductBuyOrderViewModel.m
//  Partner
//
//  Created by  rjt on 15/12/7.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductBuyOrderViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ProductPanKouEntity.h"
#import "ContractsEntity.h"
#import "AvailableCreditEntity.h"
#import "OrdersBuyEntity.h"

@implementation STOProductBuyOrderViewModel
-(void)viewModelDidLoad{
    [super viewModelDidLoad];
    self.manager = [STOProductManager shareSTOProductManager];
    self.maxMoney = @500000;
    self.minMoney = @10000;
    @weakify(self);

    StockEntity *ent = self.manager.chosedStock;
    _name = ent.stockName;
    _code = ent.stockCode;
    [[ProductManager shareProductManager] getUserContracts:^(EFEntity *entity, NSError *error) {
        @strongify(self);
        if (error==nil && [entity isKindOfClass:[ContractsEntity class]]) {
            self.contracts = ((ContractsEntity*)entity).records;
            
            NSLog(@"self.contracts = %@",self.contracts);
        }
    }];
    
    self.confirmCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (self.selectContract) {
                [self.manager buyWithCode:self.manager.chosedStock.stockCode andAmount:self.currentValue.description  andPrice:self.currentPrice.description andContractId:self.selectContract.ID andReturnBlock:^(EFEntity *entity, NSError *error) {
                    if (error==nil && [entity isKindOfClass:[OrdersBuyEntity class]]) {
                        [subscriber sendNext:@(YES)];
                    }else {
                        [subscriber sendNext:@(NO)];
                    }
                    [subscriber sendCompleted];
                 
                }];
            }else{
                [subscriber sendError:RACErrorFromMsg(@"请选择一个合约")];
            }
            return nil;
        }];
        
    }];
}

-(void)getHqData{
    if (self.manager.chosedStock) {
        @weakify(self);
        [self.manager refreshPankou:^(EFEntity *entity, NSError *error) {
            @strongify(self);
            if (error==nil && [entity isKindOfClass:[ProductPanKouEntity class]]) {
                ProductPanKouEntity *e = (ProductPanKouEntity*)entity;
                self.closePrice = [NSString stringWithFormat:@"%.2f",[e.YClose floatValue]];
                self.closePriceColor = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.YClose floatValue]];
                self.lowPrice = [NSString stringWithFormat:@"%.2f",[e.Low floatValue]];
                self.lowPriceColor = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Low floatValue]];
                self.highPrice = [NSString stringWithFormat:@"%.2f",[e.High floatValue]];
                self.highPriceColor = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.High floatValue]];
                self.openPrice = [NSString stringWithFormat:@"%.2f",[e.Open floatValue]];
                self.openPriceColor = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Open floatValue]];
                self.currentPrice = [NSString stringWithFormat:@"%.2f",[e.New floatValue]];
                self.currentPriceColor = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.New floatValue]];
                float rhythm = [e.New doubleValue] - [e.YClose doubleValue];
                self.rhythm = [NSString stringWithFormat:@"%@%.2f",rhythm>0?@"+":@"",rhythm] ;
                float precent = ([e.New doubleValue] - [e.YClose doubleValue]) / [e.YClose doubleValue] * 100;
                self.precent = [NSString stringWithFormat:@"%@%.2f%%",precent>0?@"+":@"",precent] ;
                
                self.sell1Vol = [self convertVol:e.SellVol1];
                self.sell2Vol = [self convertVol:e.SellVol2];
                self.sell3Vol = [self convertVol:e.SellVol3];
                self.sell4Vol = [self convertVol:e.SellVol4];
                self.sell5Vol = [self convertVol:e.SellVol5];
                
                self.buy1Vol = [self convertVol:e.BuyVol1];
                self.buy2Vol = [self convertVol:e.BuyVol2];
                self.buy3Vol = [self convertVol:e.BuyVol3];
                self.buy4Vol = [self convertVol:e.BuyVol4];
                self.buy5Vol = [self convertVol:e.BuyVol5];
                
                self.sell1Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Sell1 floatValue]];
                self.sell2Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Sell2 floatValue]];
                self.sell3Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Sell3 floatValue]];
                self.sell4Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Sell4 floatValue]];
                self.sell5Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Sell5 floatValue]];
                
                self.buy1Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Buy1 floatValue]];
                self.buy2Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Buy2 floatValue]];
                self.buy3Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Buy3 floatValue]];
                self.buy4Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Buy4 floatValue]];
                self.buy5Color = [AppUtil colorWithOpen:[e.YClose floatValue] andNew:[e.Buy5 floatValue]];
                self.sell1 = [NSString stringWithFormat:@"%.2f",[e.Sell1 floatValue]];
                self.sell2 = [NSString stringWithFormat:@"%.2f",[e.Sell2 floatValue]];
                self.sell3 = [NSString stringWithFormat:@"%.2f",[e.Sell3 floatValue]];
                self.sell4 = [NSString stringWithFormat:@"%.2f",[e.Sell4 floatValue]];
                self.sell5 = [NSString stringWithFormat:@"%.2f",[e.Sell5 floatValue]];
                
                self.buy1 = [NSString stringWithFormat:@"%.2f",[e.Buy1 floatValue]];
                self.buy2 = [NSString stringWithFormat:@"%.2f",[e.Buy2 floatValue]];
                self.buy3 = [NSString stringWithFormat:@"%.2f",[e.Buy3 floatValue]];
                self.buy4 = [NSString stringWithFormat:@"%.2f",[e.Buy4 floatValue]];
                self.buy5 = [NSString stringWithFormat:@"%.2f",[e.Buy5 floatValue]];
            }
            
        }];
    }
}

-(NSString*)convertVol:(NSString*)vol{
    if ([vol floatValue]/100>10000) {
        return [NSString stringWithFormat:@"%.2f万",[vol floatValue]/100/10000];
    }else{
        return [NSString stringWithFormat:@"%ld",[vol integerValue]/100];
    }
    
}


-(void)setSelectContract:(ContractsRecordsEntity *)selectContract{
    if (selectContract) {
        _selectContract = selectContract;
        @weakify(self);
        [[ProductManager shareProductManager] availableCreditWithContractId:selectContract.ID andBlock:^(EFEntity *entity, NSError *error) {
            @strongify(self);
            if (error == nil && [entity isKindOfClass:[AvailableCreditEntity class]]) {
                AvailableCreditEntity* ent = (AvailableCreditEntity*)entity;
                self.maxMoney = @([ent.availableCredit floatValue]);
                self.minMoney = @10000;
                self.currentValue = self.minMoney;
            }
        }];
    }
}
@end
