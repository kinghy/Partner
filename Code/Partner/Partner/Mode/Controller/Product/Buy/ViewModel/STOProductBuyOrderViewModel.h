//
//  STOProductBuyOrderViewModel.h
//  Partner
//
//  Created by  rjt on 15/12/7.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBaseViewModel.h"
@class RACCommand;
@class ContractsRecordsEntity;
@interface STOProductBuyOrderViewModel : EFBaseViewModel
@property (nonatomic) NSNumber *maxMoney;
@property (nonatomic) NSNumber *minMoney;

@property (nonatomic,strong) id moneyValue;
@property (nonatomic,strong) NSNumber *currentValue;
@property (nonatomic,strong) NSNumber *counts;
@property (nonatomic,strong) NSNumber *currentPrice;

@property (nonatomic,strong) NSNumber *lastestPrice;
@property (nonatomic,strong) NSNumber *closePrice;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *code;

@property (nonatomic,strong) NSString *contractNO;
@property (nonatomic,strong) NSArray *contracts;
@property (nonatomic,strong) RACCommand* confirmCmd;
@property (nonatomic,strong) ContractsRecordsEntity *selectContract;

@property (nonatomic,strong) STOProductManager *manager;

-(void)getHqData;
-(void)setSelectContract:(ContractsRecordsEntity *)selectContract;
@end