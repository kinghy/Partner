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

@property (nonatomic,strong) NSNumber *maxMoney;
@property (nonatomic,strong) NSNumber *minMoney;
@property (nonatomic,strong) NSNumber *currentValue;

@property (nonatomic,strong) NSString *currentPrice;
@property (nonatomic,strong) UIColor *currentPriceColor;
@property (nonatomic,strong) NSString *precent;
@property (nonatomic,strong) NSString *rhythm;
@property (nonatomic,strong) NSString *openPrice;
@property (nonatomic,strong) NSString *highPrice;
@property (nonatomic,strong) NSString *lowPrice;
@property (nonatomic,strong) NSString *closePrice;
@property (nonatomic,strong) UIColor *openPriceColor;
@property (nonatomic,strong) UIColor *highPriceColor;
@property (nonatomic,strong) UIColor *lowPriceColor;
@property (nonatomic,strong) UIColor *closePriceColor;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *code;


@property (weak, nonatomic) IBOutlet NSString *sell1;
@property (weak, nonatomic) IBOutlet NSString *sell2;
@property (weak, nonatomic) IBOutlet NSString *sell3;
@property (weak, nonatomic) IBOutlet NSString *sell4;
@property (weak, nonatomic) IBOutlet NSString *sell5;

@property (weak, nonatomic) IBOutlet NSString *buy1;
@property (weak, nonatomic) IBOutlet NSString *buy2;
@property (weak, nonatomic) IBOutlet NSString *buy3;
@property (weak, nonatomic) IBOutlet NSString *buy4;
@property (weak, nonatomic) IBOutlet NSString *buy5;

@property (weak, nonatomic) IBOutlet NSString *sell1Vol;
@property (weak, nonatomic) IBOutlet NSString *sell2Vol;
@property (weak, nonatomic) IBOutlet NSString *sell3Vol;
@property (weak, nonatomic) IBOutlet NSString *sell4Vol;
@property (weak, nonatomic) IBOutlet NSString *sell5Vol;

@property (weak, nonatomic) IBOutlet NSString *buy1Vol;
@property (weak, nonatomic) IBOutlet NSString *buy2Vol;
@property (weak, nonatomic) IBOutlet NSString *buy3Vol;
@property (weak, nonatomic) IBOutlet NSString *buy4Vol;
@property (weak, nonatomic) IBOutlet NSString *buy5Vol;

@property (weak, nonatomic) IBOutlet UIColor *sell1Color;
@property (weak, nonatomic) IBOutlet UIColor *sell2Color;
@property (weak, nonatomic) IBOutlet UIColor *sell3Color;
@property (weak, nonatomic) IBOutlet UIColor *sell4Color;
@property (weak, nonatomic) IBOutlet UIColor *sell5Color;

@property (weak, nonatomic) IBOutlet UIColor *buy1Color;
@property (weak, nonatomic) IBOutlet UIColor *buy2Color;
@property (weak, nonatomic) IBOutlet UIColor *buy3Color;
@property (weak, nonatomic) IBOutlet UIColor *buy4Color;
@property (weak, nonatomic) IBOutlet UIColor *buy5Color;

@property (nonatomic,strong) STOProductManager *manager;

@property (nonatomic,strong) NSArray* contracts;
@property (nonatomic,strong) RACCommand* confirmCmd;

@property (nonatomic,strong) ContractsRecordsEntity* selectContract;

-(void)getHqData;
-(void)setSelectContract:(ContractsRecordsEntity *)selectContract;
@end
