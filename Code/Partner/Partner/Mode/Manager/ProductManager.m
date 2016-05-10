//
//  ProductManager.m
//  Partner
//
//  Created by  rjt on 15/11/17.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "ProductManager.h"
#import "MarketParam.h"
#import "UserContractsParam.h"
#import "AvailableCreditParam.h"

@implementation ProductManager
single_implementation(ProductManager)
-(void)getMarkets:(EFManagerRetBlock)returnBlock{
    MarketParam *param = [MarketParam param];
    [[EFConnector connector] run:param returnBlock:
     ^(NSURLSessionDataTask *task, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
     }];
}

-(void)getUserContracts:(EFManagerRetBlock)returnBlock{
    UserContractsParam *param = [UserContractsParam param];
    param.marketId = self.selectedMarket.ID;
    [[EFConnector connector] run:param returnBlock:
     ^(NSURLSessionDataTask *task, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
     }];
}

-(void)availableCreditWithContractId:(NSString*)cid andBlock:(EFManagerRetBlock)returnBlock{
    AvailableCreditParam *param = [AvailableCreditParam param];
    param.contractId = cid;
    [[EFConnector connector] run:param returnBlock:
     ^(NSURLSessionDataTask *task, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
     }];
}

@end
