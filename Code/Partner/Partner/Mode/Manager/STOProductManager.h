//
//  STOProductManager.h
//  Partner
//
//  Created by  rjt on 15/10/22.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBaseManager.h"

#import "StockEntity.h"
#import "ProductOrdersEntity.h"

@interface STOProductManager : EFBaseManager{
    StockEntity *_chosedStock;
}
single_interface(STOProductManager)

/*!
 *  @brief  选择的股票
 *
 *  @param stock 选择的股票
 */
-(void)chooseStock:(StockEntity*)stock;

@property (nonatomic,strong,readonly) StockEntity *chosedStock;

-(void)chooseOrder:(ProductOrdersRecordsEntity*)order;

@property (nonatomic,strong,readonly) ProductOrdersRecordsEntity *chosedOrder;

/** 刷新行情**/
-(void)refreshHQWithCode:(NSString*)code Block:(EFManagerRetBlock)returnBlock;

/** 刷新分时图**/
-(void)refreshChart:(EFManagerRetBlock)returnBlock;
//
///** 刷新交易量图**/
-(void)refreshVolChart:(EFManagerRetBlock)returnBlock;
//
///** 刷新K线图**/
-(void)refreshKChart:(EFManagerRetBlock)returnBlock;

/** 刷新盘口**/
-(void)refreshPankou:(EFManagerRetBlock)returnBlock;

/** 下单**/
-(void)buyWithCode:(NSString*)code andAmount:(NSString*)amount andPrice:(NSString*)price andContractId:(NSString*)cid andReturnBlock:(EFManagerRetBlock)returnBlock;
/** 买单**/
-(void)sellWithCode:(NSString*)code andAmount:(NSString*)amount andPrice:(NSString*)price andContractId:(NSString*)cid andReturnBlock:(EFManagerRetBlock)returnBlock;

/** 可卖列表**/
-(void)sellListWithContractId:(NSString*)cid andReturnBlock:(EFManagerRetBlock)returnBlock;

@end
