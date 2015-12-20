//
//  ProductManager.h
//  Partner
//
//  Created by  rjt on 15/11/17.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBaseManager.h"
#import "MarketEntity.h"

@interface ProductManager : EFBaseManager
single_interface(ProductManager)
@property (nonatomic,strong) MarketRecordsEntity *selectedMarket;

-(void)getMarkets:(EFManagerRetBlock)returnBlock;

-(void)getUserContracts:(EFManagerRetBlock)returnBlock;

-(void)availableCreditWithContractId:(NSString*)cid andBlock:(EFManagerRetBlock)returnBlock;

@end
