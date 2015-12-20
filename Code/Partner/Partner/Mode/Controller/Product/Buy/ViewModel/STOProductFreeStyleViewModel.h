//
//  STOProductFreeStyleViewModel.h
//  Partner
//
//  Created by  rjt on 15/12/9.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBaseViewModel.h"

@interface STOProductFreeStyleViewModel : EFBaseViewModel

@property (nonatomic,strong) STOProductManager *manager;

@property (nonatomic,strong) NSNumber* indexYSH;//昨收价上海
@property (nonatomic,strong) NSNumber* indexSH;//最新价上海

@property (nonatomic,strong) NSNumber* indexYSZ;//昨收价深圳
@property (nonatomic,strong) NSNumber* indexSZ;//最新价深圳

@property (nonatomic,strong) NSArray* myStocks;

-(void)refreshHq;
-(void)refreshMyStock;
@end
