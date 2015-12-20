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
    RACSignal *valueSignal = [RACObserve(self, moneyValue) map:^id(UISlider* slider) {
        @strongify(self);
        if (slider.value == 0) {
            return @(self.minMoney.integerValue);
        }else{
            return @(slider.value*10000);
        }
    }];
    [valueSignal subscribeNext:^(NSNumber *value) {
        @strongify(self);
        self.currentValue = value;
    }];

    StockEntity *ent = self.manager.chosedStock;
    _name = ent.stockName;
    _code = ent.stockCode;
    [[ProductManager shareProductManager] getUserContracts:^(EFEntity *entity, NSError *error) {
        @strongify(self);
        if (error==nil && [entity isKindOfClass:[ContractsEntity class]]) {
            self.contracts = ((ContractsEntity*)entity).records;
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
                self.closePrice = @([e.YClose doubleValue]);
                self.lastestPrice = @([e.New doubleValue]);
            }
        }];
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
                self.currentValue = self.minMoney;
            }
        }];
    }
}
@end
