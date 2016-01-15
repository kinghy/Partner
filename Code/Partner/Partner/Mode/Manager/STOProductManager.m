//
//  STOProductManager.m
//  Partner
//
//  Created by  rjt on 15/10/22.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductManager.h"
#import "ProductPanKouParam.h"
#import "ProductChartParam.h"
#import "ProductVolChartParm.h"
#import "ProductKChartParam.h"
#import "ProductHqsParam.h"
#import "OrdersBuyParam.h"
#import "OrdersSellParam.h"
#import "ProductOrdersParam.h"

@implementation STOProductManager
single_implementation(STOProductManager)

-(void)chooseStock:(StockEntity*)stock{
    if (stock) {
        NSDictionary *dict = @{@"stockName":stock.stockName,@"stockCode":stock.stockCode,@"codeShsz":stock.codeShsz};
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:kStockLastChosed];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _chosedStock = stock;
    }
}

-(void)chooseOrder:(ProductOrdersRecordsEntity*)order{
    _chosedOrder = order;
}


/** 获取等待列表最新行情 **/
-(void)refreshHQWithCode:(NSString*)code Block:(EFManagerRetBlock)returnBlock{
    ProductHqsParam *param = [ProductHqsParam param];
    if (code!=nil&&![code isEqualToString:@""]) {
        param.code = code;
        [[EFConnector connector] run:param returnBlock:
         ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
             if(returnBlock!=nil){
                 returnBlock(entity,error);
             }
             
        }];
    }
}


/** 刷新分时图**/
-(void)refreshChart:(EFManagerRetBlock)returnBlock{
    
    ProductChartParam *param = [ProductChartParam param];
    param.code = self.chosedStock.stockCode;
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
     }];
}

/** 刷新交易量图**/
-(void)refreshVolChart:(EFManagerRetBlock)returnBlock{
    ProductVolChartParam *param = [ProductVolChartParam param];
    param.code = self.chosedStock.stockCode;
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
         
    }];
}
//
/** 刷新K线图**/
-(void)refreshKChart:(EFManagerRetBlock)returnBlock{
    ProductKChartParam *param = [ProductKChartParam param];
    param.code = self.chosedStock.stockCode;
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
         
     }];
}
//
///** 刷新盘口**/
-(void)refreshPankou:(EFManagerRetBlock)returnBlock{
    ProductPanKouParam *param = [ProductPanKouParam param];
    param.code = self.chosedStock.stockCode;
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }

     }];

}

-(void)buyWithCode:(NSString*)code andAmount:(NSString*)amount andPrice:(NSString*)price andContractId:(NSString*)cid andReturnBlock:(EFManagerRetBlock)returnBlock{
    OrdersBuyParam *param = [OrdersBuyParam param];
    param.stockNo = code;
    param.contractId = cid;
    param.amount = amount;
    param.price = price;
    NSInteger num = [amount floatValue]/[price floatValue]/100;
    num = num *100;
    param.count = [NSString stringWithFormat:@"%ld",num];
    
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
         
     }];
}

-(void)sellWithCode:(NSString*)code andAmount:(NSString*)amount andPrice:(NSString*)price andContractId:(NSString*)cid andReturnBlock:(EFManagerRetBlock)returnBlock{
    OrdersSellParam *param = [OrdersSellParam param];
    param.stockNo = code;
    param.contractId = cid;
    param.amount = amount;
    param.price = price;
    NSInteger num = [amount floatValue]/[price floatValue]/100;
    num = num *100;
    param.count = [NSString stringWithFormat:@"%ld",num];
    
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
         
     }];
}

-(void)sellListWithContractId:(NSString *)cid andReturnBlock:(EFManagerRetBlock)returnBlock{
    ProductOrdersParam *param = [ProductOrdersParam param];
    param.contractId = cid;
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
         
     }];
}


@end
