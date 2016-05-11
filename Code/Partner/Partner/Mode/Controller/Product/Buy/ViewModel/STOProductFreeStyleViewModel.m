//
//  STOProductFreeStyleViewModel.m
//  Partner
//
//  Created by  rjt on 15/12/9.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductFreeStyleViewModel.h"
#import "ProductHqsEntity.h"
#import "STODBManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation STOProductFreeStyleViewModel
-(void)viewModelDidLoad{
    [super viewModelDidLoad];
    self.manager = [STOProductManager shareSTOProductManager];
}

-(void)refreshHq{
    @weakify(self);
    NSString *code = @"sh.999999;399001;";
    [self.manager refreshHQWithCode:code Block:^(EFEntity *entity, NSError *error) {
        @strongify(self);
        ProductHqsEntity *hqEntity = (ProductHqsEntity *)entity;
        if (hqEntity==nil) {
            return;
        }
        for (ProductHqsRecordsEntity *e in hqEntity.records) {
            if ([[e.stockcode lowercaseString] isEqualToString:@"sh.999999"]) {
                self.indexYSH = [NSNumber numberWithFloat:[e.YClose floatValue]];
                self.indexSH =  [NSNumber numberWithFloat:[e.New floatValue]];
            }else if ([[e.stockcode lowercaseString] isEqualToString:@"399001"]){
                self.indexYSZ = [NSNumber numberWithFloat:[e.YClose floatValue]];
                self.indexSZ =  [NSNumber numberWithFloat:[e.New floatValue]];
            }
        }
    }];
}

-(void)addMyStocks:(NSString*)stockCode{
    [[STODBManager shareSTODBManager] addMyStockWithStockCode:stockCode];
}

-(void)refreshMyStock{
    NSArray *array = [STODBManager shareSTODBManager].myStockArr;

    if (array && array.count>0) {
        @weakify(self);
        NSMutableString *code = [NSMutableString string];
        self.myStocksEntities = array;
        self.myStocks = [[array.rac_sequence map:^id(StockEntity* entity) {
            [code appendFormat:@"%@;",entity.stockCode];
            ProductHqsRecordsEntity* e = [ProductHqsRecordsEntity entity];
            e.stockcode = entity.stockCode;
            e.stockname = entity.stockName;
            for (ProductHqsRecordsEntity *mystock in self.myStocks) {
                if (entity.stockCode == mystock.stockcode) {
                    e.New = mystock.New;
                    e.YClose = mystock.YClose;
                    e.Buy1 = mystock.Buy1;
                    e.Sell1 = mystock.Sell1;
                    break;
                }
            }
            return e;
        }] array];
        
        [self.manager refreshHQWithCode:code Block:^(EFEntity *entity, NSError *error) {
            @strongify(self);
            NSMutableArray* newmystocks = [NSMutableArray array];
            ProductHqsEntity *hqEntity = (ProductHqsEntity *)entity;
            if (hqEntity!=nil) {
                for (ProductHqsRecordsEntity *mystock in self.myStocks) {
                    ProductHqsRecordsEntity* newEntity = mystock;
                    for (ProductHqsRecordsEntity *record in hqEntity.records) {
                        if ([record.stockcode isEqualToString:mystock.stockcode]) {
                            newEntity.New = record.New;
                            newEntity.YClose = record.YClose;
                            newEntity.Buy1 = record.Buy1;
                            newEntity.Sell1 = record.Sell1;
                            break;
                        }
                    }
                    [newmystocks addObject:newEntity];
                }
                self.myStocks = newmystocks;
            }
        }];
    }else{
        self.myStocksEntities = [NSArray array];
        self.myStocks = [NSArray array];
    }
    
}

-(void)removeMyStock:(NSInteger)index{
    ProductHqsRecordsEntity* entity = [self.myStocks objectAtIndex:index];
    [[STODBManager shareSTODBManager] deleteMyStockWithStockCode:entity.stockcode];
    [self refreshMyStock];
}

@end